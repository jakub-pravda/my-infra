{
  lib,
  bifrostPort,
  allowedUsers,
  ...
}:
{
  version = "1.2.1";
  cache = true;

  registration = {
    socialLogins = [ "google" ];
    allowedDomains = lib.unique (map (u: builtins.elemAt (builtins.split "@" u) 2) allowedUsers);
  };

  endpoints = {
    custom = [
      {
        name = "Bifrost";
        # Resolved from the BIFROST_OPENAI_KEY credential at runtime
        apiKey = "\${BIFROST_OPENAI_KEY}";
        baseURL = "http://127.0.0.1:${toString bifrostPort}/v1";
        models = {
          default = [
            "openai/gpt-4o-mini"
            "openai/gpt-4o"
          ];
          fetch = false;
        };
        titleConvo = true;
        titleModel = "current_model";
        modelDisplayLabel = "Bifrost";
      }
    ];
  };
}
