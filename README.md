# Site for Online Debating Tabbing #

### [Blog](http://newtabware.blogspot.com/) ###
There is a [blog](http://newtabware.blogspot.com/) for this project.
Keeps non-techies upto speed with progress and allows full commenting 
power so people can steer us in the right direction or suggest cool features.

### What's going on? ###
The only software used to coordinate debating tournaments which is 
entirely trusted is [Tournaman](http://tournaman.wikidot.com/)
here are a few online platform starting 
to emerge but they have proven not to work - often causing disruptions to 
tournaments. This project is another attempt to solve the problem.

We aim to create tab software which will facilitate automatic registration, 
automatically computed statistics and use correct implementations of algorithms
to prevent the same failures that other platforms led to.

### Currently ###
* A proof of algorithm (sort of like a proof of concept) can be found 
in the root directory, [test1.rb](https://github.com/julianborrey/TabHub/blob/master/test1.rb) 
which simulates the allocation of teams and rooms for the next round.

* Apart from that is a bunch of code to support user accounts and so on.

* The next thing to come is the instance creation of a tournament on the server.

### Contribution ###
It is an open source project. Why?
* Should make for a better site - the more skills the better.
* It's quicker to work with others.
* It will be an entirely free entity.

Some understanding of debating will be needed for somethings but when 
it comes to generic things like user accounts and the like, all 
experience is quite valuable. Please let me know/code something if you 
could see improvements. Especially in terms of reliability and security.
Areas which you can never fully account for. See the 
[Style](https://github.com/julianborrey/superTab/wiki/Style) page on the 
wiki if you are going to write some code.

### Credit ###
Much of the boiler plate comes from Michael Hartl's [Rails Tutorial](http://ruby.railstutorial.org/).
It is a brilliant tutorial and was the framework for the site, particularly the user infrastructure.
