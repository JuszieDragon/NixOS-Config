{ catalog, config, inputs, lib, ... }:
let
  cfg = catalog.services.a2o4;
  stateDir = "/state/a2o4";
in lib.mkIf cfg.isEnabled {
    age.secrets.a2o4 = {
      file = inputs.self + /secrets/a2o4.age;
      owner = "a2o4";
    }; 

    services.a2o4-server = {
      enable = cfg.isEnabled;
      inherit (cfg) port;
      ao3_login_file = config.age.secrets.a2o4.path;
      download_dir = stateDir;
      state_dir = stateDir;
      default_format = "Epub";
      devices = [
        {
          name = "Xteink X4";
          ip = "192.168.2.9";
          port = 81;
          username = "";
          password = "";
          upload_dir = "/Fanfics";
          client = "crosspoint";
          # uses_koreader = false;
        }
        {
          name = "Phone";
          ip = "127.0.0.2";
          port = 22;
          username = "root";
          password = "root";
          upload_dir = "/fanfics/sorted";
          client = "sftp";
          # uses_koreader = false;
        }
      ];
      fandom_map = {
        "Fallout 4" = "Fallout";
        "Fallout (Video Games)" = "Fallout";
        "Baldur's Gate (Video Games)" = "Baldur's Gate";
        "Cyberpunk 2077 (Video Game)" = "Cyberpunk 2077";
        "Cyberpunk & Cyberpunk 2020 (Roleplaying Games)" = "Cyberpunk 2077";
        "Persona 5" = "Persona";
        "Persona 5 Royal" = "Persona";
        "Persona 5 Strikers" = "Persona";
        "Persona 4" = "Persona";
        "Persona 3" = "Persona";
        "persona - Fandom" = "Persona";
        "Persona Series" = "Persona";
        "逆転裁判 | Gyakuten Saiban | Ace Attorney" = "Ace Attorney";
        "大逆転裁判 | Dai Gyakuten Saiban | The Great Ace Attorney Chronicles (Video Games)" = "Ace Attorney";
        "NieR = Automata (Video Game)" = "NieR";
        "Dungeons & Dragons (Roleplaying Game)" = "Dungeons & Dragons";
        "Shin Megami Tensei Series" = "Shin Megami Tensei";
        "Pocket Monsters | Pokemon - All Media Types" = "Pokémon";
        "Pocket Monsters | Pokemon (Main Video Game Series)" = "Pokémon";
        "Pocket Monsters | Pokemon (Anime)" = "Pokémon";
        "Pocket Monsters: Diamond & Pearl & Platinum | Pokemon Diamond Pearl Platinum Versions" = "Pokémon";
        "Pocket Monsters: Sword & Shield | Pokemon Sword & Shield Versions" = "Pokémon";
        "Dragon Age: Origins" = "Dragon Age";
        "Dragon Age - All Media Types" = "Dragon Age";
        "Disco Elysium (Video Game)" = "Disco Elysium";
        "Monster Prom (Visual Novel)" = "Monster Prom";
        "Portal (Video Game)" = "Portal";
        "Slay the Princess (Visual Novel)" = "Slay the Princess";
        "Stardew Valley (Video Game)" = "Stardew Valley";
        "崩坏：星穹铁道 | Honkai: Star Rail (Video Game)" = "Honkai Star Rail";
        "Elder Scrolls V: Skyrim" = "Elder Scrolls V Skyrim";
        "Mass Effect 2 - Fandom" = "Mass Effect";
        "Mass Effect Trilogy" = "Mass Effect";
        "Mass Effect - All Media Types" = "Mass Effect";
        "XCOM (Video Games) & Related Fandoms" = "XCOM";
        "Mouthwashing (Video Game)" = "Mouthwashing";
        "この素晴らしい世界に祝福を! | KonoSuba: God's Blessing on this Wonderful World! (Anime & Manga)" = "KonoSuba";
        "ウマ娘 プリティーダービー | Uma Musume: Pretty Derby (Video Game)" = "Uma Musume";
        "ウマ娘 プリティーダービー | Uma Musume: Pretty Derby (Anime)" = "Uma Musume";
        "ウマ娘 | Uma Musume - All Media Types" = "Uma Musume";
        "니케: 승리의 여신 | Goddess of Victory: Nikke (Video Game)" = "Nikke";
        "少女前线 | Girls' Frontline (Video Game)" = "Girls Frontline";
        "Project Hail Mary - Andy Weir" = "Project Hail Mary";
        "Project Hail Mary (2026)" = "Project Hail Mary";
      };
      fandom_filters = [
        {"Baldur's Gate" = ["Dungeons & Dragons" "Original Work"];}
        {"Persona" = [ "Shin Megami Tensei" ];}
        {"Dungeons & Dragons" = [ "Original Work" ];}
        {"Original Work" = [ "*" ];}
      ];
    };

    systemd.tmpfiles.settings.a2o4-server."${stateDir}".d = {
      user = "a2o4";
      group = "a2o4";
      mode = "0775";
    };
  }
