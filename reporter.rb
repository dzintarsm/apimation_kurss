require 'json'
require_relative 'features/support/api_helper.rb'

build_number = ARGV[0]

job_url = ARGV[1]

thumbnail = { 'url' => 'http://www.la.lv/wp-content/uploads/2014/10/gurkis_66622975-664x458.jpg'}

#sakuma tuksh masivs
fields = []
fields.push( {'Jenkins_job' => 'Author', 'value' => job_url})
fields.push( {'name' => 'Build_number', 'value' => build_number})

embed = []
embed.push({'title' => 'Rich content',
           'color' => 4387956,
           'fields' => fields,
           'thumbnail' => thumbnail})

payload = {'content' => 'automators', 'embed' => embed}.to_json

post("https://discordapp.com/api/webhooks/393067525451022336/uz2WgUi_8-6oS9zy2Pu_3l_-CtQvabdSlgflF_ojyxTxWgxO_8Vdj0qBDMNixDj6wlT1",
                            headers: { 'Content-Type' => 'application/json' },
                            cookies: {},
                            payload: payload)
