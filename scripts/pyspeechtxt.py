import pyttsx

sayer = pyttsx.init()

sayer.setProperty('rate', 100)

voices = sayer.getProperty('voices')
for voice in voices:
  print "Using voice:", repr(voice)
  sayer.setProperty('voice', voice.id)
  sayer.say("Hi there, how's you ?")
  sayer.say("A B C D E F G H I J K L M")
  sayer.say("N O P Q R S T U V W X Y Z")
  sayer.say("0 1 2 3 4 5 6 7 8 9")
  sayer.say("Sunday Monday Tuesday Wednesday Thursday Friday Saturday")
  sayer.say("Violet Indigo Blue Green Yellow Orange Red")
  sayer.say("Apple Banana Cherry Date Guava")
sayer.runAndWait()
