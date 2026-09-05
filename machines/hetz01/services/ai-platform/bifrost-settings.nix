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
            "gpt-5"
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
          models = [
            "claude-sonnet-5"
          ];
          weight = 1.0;
        }
      ];
    };
    gemini = {
      keys = [
        {
          name = "gemini-key";
          value = "env.GEMINI_API_KEY";
          models = [
            "gemini-3.1-flash-image"
          ];
          weight = 1.0;
        }
      ];
    };
  };
  governance = {
    virtual_keys = [
      {
        id = "librechat-sramek";
        name = "Sramek copilot models";
        description = "Sramek copilot models - configured in librechat";
        is_active = true;
        provider_configs = [
          {
            provider = "openai";
            key_ids = [ "*" ];
            allowed_models = [ "gpt-5" ];
          }
          {
            provider = "anthropic";
            key_ids = [ "*" ];
            allowed_models = [ "claude-sonnet-5" ];
          }
          {
            provider = "gemini";
            key_ids = [ "*" ];
            allowed_models = [ "gemini-3.1-flash-image" ];
          }
        ];
      }
    ];
    budgets = [
      {
        id = "sramek-copilot";
        virtual_key_id = "librechat-sramek";
        max_limit = 200.00;
        reset_duration = "1M";
        calendar_aligned = true;
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
