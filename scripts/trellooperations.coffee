# Description:
#   Create new cards in Trello
#
# Dependencies:
#   "node-trello": "latest"
#
# Configuration:
#   SOBRRBOT_TRELLOIDEA_KEY - Trello application key
#   SOBRRBOT_TRELLOIDEA_TOKEN - Trello API token
#   SOBRRBOT_TRELLO_OPERATIONS_IDEA_LIST - The list ID that you'd like to create cards for
#
# Commands:
#   hubot trello operations card <name> - Create a new Trello card in Operations board, To Do list
#
# Notes:
#   To get your key, go to: https://trello.com/1/appKey/generate
#   To get your token, go to: https://trello.com/1/authorize?key=<<your key>>&name=Hubot+Trello&expiration=never&response_type=token&scope=read,write
#   Figure out what board you want to use, grab it's id from the url (https://trello.com/board/<<board name>>/<<board id>>)
#   To get your list ID, go to: https://trello.com/1/boards/<<board id>>/lists?key=<<your key>>&token=<<your token>>  "id" elements are the list ids.
#
# Author:
#   carmstrong

module.exports = (robot) ->
  robot.respond /trello operations (.*)/i, (msg) ->
    cardName = msg.match[1]
    if not cardName.length
      msg.send "You must give the card a name"
      return
    if not process.env.SOBRRBOT_TRELLOIDEA_KEY
      msg.send "Error: Trello app key is not specified"
    if not process.env.SOBRRBOT_TRELLOIDEA_TOKEN
      msg.send "Error: Trello token is not specified"
    if not process.env.SOBRRBOT_TRELLO_OPERATIONS_IDEA_LIST
      msg.send "Error: Trello list ID is not specified"
    if not (process.env.SOBRRBOT_TRELLOIDEA_KEY and process.env.SOBRRBOT_TRELLOIDEA_TOKEN and process.env.SOBRRBOT_TRELLO_OPERATIONS_IDEA_LIST)
      msg.send "ERROR1"
      return
    createCard msg, cardName

createCard = (msg, cardName) ->
  Trello = require("node-trello")
  t = new Trello(process.env.SOBRRBOT_TRELLOIDEA_KEY, process.env.SOBRRBOT_TRELLOIDEA_TOKEN)
  t.post "/1/cards", {name: cardName, idList: process.env.SOBRRBOT_TRELLO_OPERATIONS_IDEA_LIST}, (err, data) ->
    if err
      msg.send "There was an error creating the card"
