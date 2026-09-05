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
        apiKey = "\${LIBRECHAT_KEY}";
        baseURL = "http://127.0.0.1:${toString bifrostPort}/v1";
        models = {
          default = [
            "openai/gpt-5"
            "anthropic/claude-sonnet-5"
            "gemini/gemini-3.1-flash-image"
          ];
          fetch = false;
        };
        titleConvo = true;
        titleModel = "Sramek copilots";
        modelDisplayLabel = "Bifrost";
      }
    ];
  };
}
