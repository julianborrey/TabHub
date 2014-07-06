#class to do flash with multiple messages
#needed once we broke away from the strick model varriables

class SmallNotice
   attr_accessor :messages

   def initialize
      @messages = {};
      return;
   end
   
   def add(type, msg)
      @messages[type] ||= [];
      @messages[type].push(msg);
      return;
   end

   def clear
      @messages = {};
      return;
   end
end
