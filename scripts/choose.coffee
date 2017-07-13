_ = require 'underscore'
request = require 'request'
print = console.log

random = (array, num) -> 
  t = [];
  choosed = [];
  len = array.length;
  n = if num < len then num else len;
  while (n-- > 0)
    i = Math.floor(Math.random() * len, 0)
    choosed[n] = t[i] or array[i]
    --len;
    t[i] = t[len] or array[len]
  return choosed

module.exports = (robot) ->
  robot.respond /choose reviewer/i, (msg) ->
#    @reviewerChannelID = "C4313HB99"
    request.get
      url: "https://slack.com/api/channels.info?token=#{process.env.HUBOT_SLACK_TOKEN}&channel=#{process.env.SLACK_CHANNEL_ID}"
      , (err, response, body) ->
        print err
        print response
        print body
        members = (member \
          for member in JSON.parse(body)["channel"]["members"])
        for id in random(members, 1)
          request.get
            url: "https://slack.com/api/users.info?token=#{process.env.HUBOT_SLACK_TOKEN}&user=#{id}"
            , (err, response, body) ->
              name = JSON.parse(body)["user"]["name"]
              msg.send "@#{name}さん、レビューお願いします。"
