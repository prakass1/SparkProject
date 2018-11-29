##########################
#Author: Subash Prakash
#Matr-ID: 220408
#####################

import tweepy
from tweepy import OAuthHandler
from tweepy import Stream
from tweepy.streaming import StreamListener
import socket
import json
from kafka import SimpleProducer, KafkaClient


# Set up credentials
consumer_key=''
consumer_secret=''
access_token =''
access_secret=''


class TweetsListener(StreamListener):

  def on_data(self, data):
      try:
          msg = json.loads( data )
          print( msg['text'].encode('utf-8') )
          producer.send_messages("fifaworldcup", msg['text'].encode('utf-8') )
          return True
      except BaseException as e:
          print("Error on_data: %s" % str(e))
      return True

  def on_error(self, status):
      print(status)
      return True


#########START OF MAIN###########################

auth = OAuthHandler(consumer_key, consumer_secret)
auth.set_access_token(access_token, access_secret)
#Kafka
kafka = KafkaClient("192.168.56.102:9092")
producer = SimpleProducer(kafka)
l = TweetsListener() 
twitter_stream = Stream(auth, l)
twitter_stream.filter(track=['messi'])

#########END OF MAIN############################
