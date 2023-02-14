# HOME ASSISTANT
- https://www.home-assistant.io/
- https://developers.home-assistant.io/
- glossary of terms: https://www.home-assistant.io/docs/glossary/
- [HACS](https://hacs.xyz/) - home assistant community store - download 3rd party plugins on github
- blog: https://www.home-assistant.io/blog/ , will have release notes

## ARCHITECTURE
- https://developers.home-assistant.io/docs/architecture_index/
- home assistant OS (formerly HassOS) - linux based OS from [buildroot](https://buildroot.org/), with add-ons
- home assistant supervisor - program that manages/upgrades home assistant OS and home assistant core
    - add-ons are created in new containers
- home assitant core - the main backend brains
- uses a SQLite db, generally located at `config/home-assistant_v2.db`
- state object: https://www.home-assistant.io/docs/configuration/state_object/
    - sensors will have a main "attribute" `state` and auxilary "attributes" listed in `attributes`
    - `last_changed` and `last_updated` (subtle differences) will store last time state "changed"

## TEMPLATING
- home assistant uses python code and jinja templates and some libs to render things
- https://www.home-assistant.io/docs/configuration/templating/
- referencing a variable: `{{ states('sensor.mysensor') }}`
- covert a input datetime to diff string format:
    - `time: "{{ (state_attr('input_datetime.adatetimeentity', 'timestamp') - 1800) | timestamp_custom('%H:%M:%S', true) }}"`
        - the 2nd arg for boolean to `timestamp_custom` will use current timezone if true
- loop over a sensor attributes and print the attribute value
    ```python
    {% for attr in states.sensor.some_sensor.attributes %}
    {% if not attr=='icon' and not attr=='friendly_name' and not attr=='unit_of_measurement' %}
       show: {{ attr }}, episode: {{ states.sensor.some_sensor.attributes[attr] }}
    {% endif %}
    {% endfor %}
    ```

## AUTOMATIONS
- multiple triggers are OR'd together

## NOTIFICATION
- `notify.notify` is generic and will call the first compatible device in the list
    - best to call `notify.some_specific_device`

## CONFIGURATION
- https://www.home-assistant.io/docs/configuration/
- after manually editting it, highly rec'd to validate the configuration file, then restart
- for template sensors, after editting configuration.yml, goto developer tools and reload just templates, don't have to restart HASS
    - this should clear deletedt template sensors from configuration.yml

## SPECIAL TYPES
- templates -> entity whose data is derived from other data
- REST service - REST service: https://www.home-assistant.io/integrations/rest/ , create sensor for REST API response
    - not be confused with REST command: https://www.home-assistant.io/integrations/rest_command/
        - this is a service type that just fires off a HTTP request somewhere (ignores response i suppose)
    - the inverse is template webhook: https://www.home-assistant.io/docs/automation/trigger/#webhook-trigger
        - client pushes data to HASS and you can create a entity/sensor from that data
- [history stats](https://www.home-assistant.io/integrations/history_stats/) - stats of another sensor, e.g. time period in a state
- entities of name `_identity` are for identifying a device (like will blink or something), many devices dont support it

## LOVELACE UI
- can add custom panels - https://www.home-assistant.io/integrations/panel_custom/
    - https://www.reddit.com/r/homeassistant/comments/10hc3vb/psa_adding_automations_to_the_left_panel
        - modifying the left sidebar in lovelace with buttons for going to automations or devices
- dashboards are stored in `.storage` in json format
- has keyboard shortcuts: https://www.home-assistant.io/docs/tools/quick-bar/
    - _NOTE_ make sure middle main panel is active (not side panel or top panel)
    - `e` -> popup to select an entity
    - `c` -> popup to run a command (navigate to a page or run some various actions)
    - `my` -> create `my` link
- feb2023 - `input_number` entity will show a movable slider if in `entities` card, not single `entity` card

## REST API
- REST API docs: https://developers.home-assistant.io/docs/api/rest
- `curl http://192.168.1.1/api/`
- calling a webhook
    - `xh -v http://127.0.0.1:8123/api/webhook/webhook_id --auth-type bearer --auth sometokenvalue jsonprop1=1 jsonprop2=4`

## CLI
- the official CLI: https://github.com/home-assistant/cli , `ha` bin
    - i think it's only available on the homeassistant OS
### HASS-CLI
- great 3rd party: https://github.com/home-assistant-ecosystem/home-assistant-cli , `hass-cli` bin
- `hass-cli config release` - get HASS version
- calling a service
    - `hass-cli service call system_log.clear` - clear logs
    - `hass-cli service call backup.create` - create a backup
    - `hass-cli service call notify.some_device --arguments message="hi there",title=whatever` - send notif
    - `hass-cli service call light.toggle --arguments entity_id=light.some_entity_name`     - toggle a light
    - `hass-cli service call media_player.play_media --arguments entity_id=media_player.spotify_entity,media_content_type=music,media_content_id=https://open.spotify.com/track/1hrRNhEG0ES4OC5rBCU1F8`
        - play a specific track or playlist in spotify
    - `hass-cli service call media_player.media_play_pause --arguments entity_id=media_player.living_room_tv` - toggle play on a media player entity
- toggle entity: `hass-cli state toggle someentity`
- call webhook, `hss raw post --json '{ "prop1" : "value1" }' /api/webhook/somehook`

## INTEGRATION
- speedtest by defaults polls every hour, can configure this in ingrations section
- spotify
    - creds in `.storage/application_credentials`
- command line integrations
    - [shell command](https://www.home-assistant.io/integrations/shell_command/)
        - just run a plain shell command
    - [command line](https://www.home-assistant.io/integrations/command_line/) - binary sensor
    - [command line sensor](https://www.home-assistant.io/integrations/sensor.command_line/) - sensor with some value
    - [command line switch](https://www.home-assistant.io/integrations/switch.command_line/) - a toggle switch
- twilio sms -> configured in `configuration.yml` and will add a notify service
    - must specify a target phone number (that in twilio API is approved), example ph format: `12223334444`

## COMPANION/MOBILE APP
- tracking limitation on no data
    - backend sensor will just use the last values, so if mobile app has no data connection, sensor will hold last known value
        - https://community.home-assistant.io/t/companion-app-not-updating-device-tracker/391752
    - automations based on location will not be wrong

## HTTP / AUTH
- http configuration: https://www.home-assistant.io/integrations/http/
- banned IPs go into file `ip_bans.yaml` in base config dir
    - remove from file and restart HASS to unban
### TLS
- https://community.home-assistant.io/t/certificate-authority-and-self-signed-certificate-for-ssl-tls/196970
    - make sure to use `-nodes` with `openssl`, HASS doesn't support passphrase on cert
- jan2023 - companion app doesnt support self signed certs, have to add it to android root trust store somehow

## NVR / CAMERA
- should really use a NVR like frigate or zoneminder, both need MQTT as mediator

## LOGS
- log file is `home-assistant.log`
- example of auth failure log
    - `2022-12-29 16:18:31.390 WARNING (MainThread) [homeassistant.components.http.ban] Login attempt or request with invalid authentication from some-device (1.1.1.1)`
- there a _2_ integrations
    - [system_log](https://www.home-assistant.io/integrations/system_log/)
        - set max entries of logs to store
        - define 2 services
            - write a log
            - clear logs (`system_log.clear`), *NOTE* this clear logs in server memory, not from the file `home-assistant.log`
                - could create a shell cmd entity that `truncate home-assistant.log --size 0` to clear the file
        - defines an event `system_log_event` for warning and error logs, so you can write automations
    - [logger](https://www.home-assistant.io/integrations/logger/)
        - set global log level and fine grained log level for specific components, services to change log level
- log namespaces:
    - `homeassistant.components.http` - for all http stuff, including sub namespaces like `ban`
    - `homeassistant.components.http.ban` - for just failed logins, bans, resetting ban counter for a good login, etc.

## BACKUPS
- they store _all_ files in the config dir, so any custom new files you create
- base backup is not gzipped tar so `tar -xvf backup.tar`, then the enbedded tar file with the actual backup data is gzipped

## DATA
- https://www.home-assistant.io/integrations/recorder/
- default retention for data is 10 days, can change this
- can add additional databases like influxDB in addition to the base recorder

## ISSUES
- if you rename a device and all it's entities, lovelace errors
    - lovelace stores entity names, not their IDs
- open client sessions will try to keep connecting, e.g. switching server from https to http caused an persisted 400 errors in logs
    - error log: `aiohttp.http_exceptions.BadStatusLine: 400, message="Bad status line 'Invalid method encountered'"`
    - exactly as https://github.com/home-assistant/core/issues/73885 , user commented he found the culprit device retrying https
- reverse proxy needs to pass upgrade headers for client(web or mobile) auth to work
    - https://community.home-assistant.io/t/home-assistant-community-add-on-nginx-proxy-manager/111830/536
        - from https://community.home-assistant.io/t/unable-to-connect-to-home-assistant-via-nginx-reverse-proxy/382937/9
    - https://docs.nginx.com/nginx/admin-guide/web-server/reverse-proxy/
        - be default nginx sets `Connection` to `close` and HASS probably needs to `upgrade` for websockets

## COMPETITORS
- [openhab](https://www.openhab.org/) is also a fully fledge FOSS home automation platform
