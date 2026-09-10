{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.services.ai-platform;
in
{
  options.services.ai-platform = {
    enable = mkEnableOption "AI platform";

    bifrost = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable the Bifrost AI gateway.";
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port the Bifrost AI gateway listens on.";
      };

      settings = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Bifrost config.json content, see services.bifrost.settings.";
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to a file supplying secrets referenced from bifrost settings, see services.bifrost.environmentFile.";
      };
    };

    librechat = {
      enable = mkOption {
        type = types.bool;
        default = cfg.enable;
        description = "Whether to enable LibreChat.";
      };

      port = mkOption {
        type = types.port;
        default = 3080;
        description = "Port LibreChat listens on.";
      };

      env = mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Extra environment variables for LibreChat, see services.librechat.env.";
      };

      credentials = mkOption {
        type = types.attrsOf types.path;
        default = { };
        description = "Secrets loaded as systemd credentials for LibreChat, see services.librechat.credentials.";
      };

      settings = mkOption {
        type = types.attrs;
        default = { };
        description = "librechat.yaml content, see services.librechat.settings.";
      };

      usersFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = literalExpression ''config.sops.secrets."librechat/allowed_users".path'';
        description = ''
          Path to a JSON file listing the accounts permitted to sign in, as
          `[ { email = "..."; role = "ADMIN" | "USER"; } ]`.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.bifrost.enable {
      services.bifrost = {
        enable = true;
        port = cfg.bifrost.port;
        settings = cfg.bifrost.settings;
        environmentFile = cfg.bifrost.environmentFile;
      };
    })

    (mkIf cfg.librechat.enable {
      services.librechat = {
        enable = true;
        enableLocalDB = true;
        env = cfg.librechat.env // {
          PORT = cfg.librechat.port;
        };
        credentials = cfg.librechat.credentials;
        settings = cfg.librechat.settings;
      };
    })

    (mkIf (cfg.librechat.enable && cfg.librechat.usersFile != null) {
      systemd.services.librechat-seed-user =
        let
          mongoUri = config.services.librechat.env.MONGO_URI;
          seedBody = pkgs.writeText "librechat-seed-user.js" ''
            const allowedEmails = allowedUsers.map((u) => u.email);

            const users = db.getSiblingDB(db.getName()).users;

            // Remove every account that is not on the allowlist. Without this
            // an account created before the allowlist was narrowed would keep
            // working.
            const removed = users.deleteMany({ email: { $nin: allowedEmails } });
            if (removed.deletedCount > 0) {
              print("removed " + removed.deletedCount + " non-permitted account(s)");
            }

            // Create or update each permitted account. `role` is kept in
            // `$set` so promoting/demoting a user between ADMIN and USER
            // takes effect on redeploy, not just on first creation.
            // `provider: "google"` is required: socialLogin.js refuses a
            // login whose existing account belongs to a different provider.
            // googleId is left unset so the first sign-in binds the real
            // Google subject by email.
            allowedUsers.forEach(({ email, role }) => {
              const result = users.updateOne(
                { email },
                {
                  $set: { role },
                  $setOnInsert: {
                    email,
                    name: email.split("@")[0],
                    username: email.split("@")[0],
                    provider: "google",
                    emailVerified: true,
                    createdAt: new Date(),
                  },
                  $currentDate: { updatedAt: true },
                },
                { upsert: true },
              );

              print(
                result.upsertedCount > 0
                  ? "seeded " + email + " (" + role + ")"
                  : email + " already present (role -> " + role + ")",
              );
            });
          '';

          runSeed = pkgs.writeShellScript "librechat-seed-user" ''
            set -euo pipefail

            roster="$CREDENTIALS_DIRECTORY/users"

            # Fail loudly on a malformed roster rather than seeding a partial
            # allowlist (which would delete every account not in the fragment).
            if ! ${lib.getExe pkgs.jq} -e 'type == "array"' "$roster" > /dev/null; then
              echo "librechat-seed-user: roster is not a JSON array" >&2
              exit 1
            fi

            script="$RUNTIME_DIRECTORY/seed.js"
            {
              printf 'const allowedUsers = %s;\n' "$(< "$roster")"
              cat ${seedBody}
            } > "$script"

            exec ${lib.getExe config.services.mongodb.mongoshPackage} \
              --quiet ${mongoUri} "$script"
          '';
        in
        {
          description = "Seed the LibreChat accounts permitted to sign in";
          wantedBy = [ "multi-user.target" ];
          # Ordered before librechat so the account exists on first sign-in.
          before = [ "librechat.service" ];
          requires = [ "mongodb.service" ];
          after = [ "mongodb.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            DynamicUser = true;
            ExecStart = runSeed;

            # sops drops secrets root-owned under /run/secrets, which a
            # DynamicUser cannot read. systemd copies the roster into a
            # tmpfs the unit owns instead.
            LoadCredential = [ "users:${cfg.librechat.usersFile}" ];
            # Exempt from ProtectSystem = "strict" below; holds the assembled
            # script, which contains the roster.
            RuntimeDirectory = "librechat-seed-user";
            RuntimeDirectoryMode = "0700";

            # Hardening: the unit only needs a loopback mongo connection.
            CapabilityBoundingSet = "";
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateTmp = true;
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectSystem = "strict";
            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
            ];
            RestrictNamespaces = true;
            RestrictRealtime = true;
            RestrictSUIDSGID = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [ "@system-service" ];
          };
        };
    })
  ];
}
