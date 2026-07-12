_: {
  "$schema" = "https://www.getbifrost.ai/schema";
  client = {
    drop_excess_requests = false;
  };
  providers = {
    openai = {
      keys = [
        {
          name = "openai-key";
          value = "env.OPENAI_API_KEY";
          models = [
            "gpt-4o-mini"
            "gpt-4o"
          ];
          weight = 1.0;
        }
      ];
    };
    anthropic = {
      keys = [
        {
          name = "anthropic-key";
          value = "env.ANTHROPIC_API_KEY";
          models = [ "*" ];
          weight = 1.0;
        }
      ];
    };
  };
  governance = {
    virtual_keys = [
      {
        id = "gardenea";
        name = "Gardenea AI";
        description = "Gardenea AI keys (local development)";
        is_active = true;
        provider_configs = [
          {
            provider = "openai";
            key_ids = [ "*" ];
            allowed_models = [ "*" ];
          }
        ];
      }
    ];
  };
  config_store = {
    enabled = true;
    type = "sqlite";
    config = {
      path = "/var/lib/bifrost/config.db";
    };
  };
}
