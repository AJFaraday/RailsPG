2013-08-17 - Afternoon
----------------------

Very beginnings, Started with classes and related skills. 

Most of the actual work this afternoon was on data loading (for internal data, not working data).

System data comes from CSV files in db/seed_tables.
The naming convention for this is:

numeric index, then the underscored, plural class name.
E.G. 01-character_classes.csv

Headers are methods to run on a newly created object:

* Those ending in = are set before saving the object
* Others are called afterwards (mostly to set relationships by name, after saving)

These are run at db:seeds, and the 'check' method on any model is called as you go. 

Check methods are a simple summary, but can also be used to weed out problems, which are then shown 
at the end of the seed loading. See app/models/character_class.rb for a strong pattern.

Hopefully, next time I`ll get closer to some game mechanics.

2013-08-17 - Evening
--------------------

This session was:
* putting in Character and it`s relationship to skills.
* Levelling up and aquiring skills (barely tested)
* Creating a very simple battle scenario (/test/unit/battle_test.rb)

This is actually a bit of a coup for me, that it`s reached this stage so quickly.
Eventually I hope to use range and speed, to make a dynamic, grid-based game, but this
is a definite step fowards. And it`s 11:41 on a Saturday night. Don`t forget that!

2013-08-18 - Afternoon
----------------------

This was mostly a testing session, using mocha to remove chance operations from rolls.

Very little new development today, but yesterdays work is a lot more solid than it has been.
The next step is probably a bit more of the battle scenario test.

2013-08-19 - Evening
--------------------

Once again, working until 11.

This time it was a test-driven run at attribute modifying effects, namely reducing armour
and increasing attack power. The test`s half-and-half completed and there`s a whole new model
for effects in play. The whole project is definitely stepping forwards in slow, well tested lumps.

I didn`t get round to a full scenario test, perhaps another time.

2013-08-20 - Evening
--------------------

Well, I`ve finished the battle system, basically. All the basic effects are there, in some form or another
but I don`t think we can have a battle yet. Range is still meaningless, as is speed, so we need some space 
to play in. So it`s time for more conceptual work. The next step, I hope, is to try out some level definitions,
again, test driven, so I`ll define a level in text, then see where it takes me. 

*Stated Aim!* define a level, then start to write tests, then models to make it work.

2013-08-20 - Even Later Evening
-------------------------------

I`ve just done the first part, a CSV and YML based adventure definition. The first being ingeniously named
"Snails on Rails". It`s literally just putting together some of the elements I`ve already defined, and there
is no code to load this into the database, or models for it to be loaded into. Or any real gameplay rules.

But just having defined this in logical terms is a huge step forwards, it`s making the next few steps a whole
lot clearer. Oh well, time to sleep (11:45 finish today), and tomorrow evening will probably be writing tests
to get this into the system as described by the yaml.

2013-08-21 - Evening
--------------------

I achieved a lot today, more or less. 

I can now test all the unit tests as a single test task, without losing the database in the proces. There`s
two new rake tasks:

* rake test:with_load
* rake test:without_load

This will make the whole app a lot easier to manage.

The other thing I achieved was a model structure for adventures, levels and doors (to connect them). These
are a template for games to be played at a later date (I suspect Game will be an instance of Adventure). I
loaded yesterdays speculative level definition structure (with only a few minor changes) into the new model
structure and tested this huge loading task. 

A couple of big achievements this evening, I`m really begining to think this might become a playable game.

2013-08-22 - Late Evening
-------------------------

This evening`s dev was held back by two things, I will be going on holiday in a couple of days, and probably
won`t proceed much further with the game or a couple of weeks, and I was out for a meal with my colleagues.

So I took a step sideways and looked at the impending problem of line-of-sight. Which is a frustrating kind
of problem, as it`s very easy to do on paper, you just stick a ruler between two points and see if there`s 
an obstacle in the way. On a big, cunky grid it`s a harder kind of problem to do it mathematically. 

Thankfully a lunch-time thinking session on a board yeilded a result from my boss, you assume half-way points
and draw a line in increments along and up in the right direction until you hit your destination, or an obstacle.

So this evening I jotted it down into lib/line\_of\_sight.rb as a genericised method and tested it. 

Seems pretty robust 

2013-08-24 - evening and night
------------------------------

I`ve done an INSANE amount of coding tonight, after a crazy week at work. I had a 3 hour train journey so I decided to really get to grips with one of the problems which was always going to eat my time, a lot! Route finding. 

I previously tried a whole project of route finding, which became a project of space-exploring, ants in a maze (www.github.com/ajfaraday/ants-in-a-maze)

After spending a lot of time on the line of sight code, I had quite a logical head on, and a hot, crowded train to ignore, so I got my teeth stuck in, and continued when I got home. It`s now gone half past midnight. but I think I`ve cracked it. 

My algorithm uses multiple strategies, compass_points towards the target, an aversion to repeat spaces and targeted back-tracking to work out the shortest path to the exit. It took me 5 hours, post work to get there. 

I`m mentally exhausted as I write this log, but genuinely proud of myself!

2013-08-25 - Afternoon
----------------------

In a hurry, no time to write logs now!

2013-08-30 - Morning
--------------------

My brother`s been around for the last week, on holiday, so I`ve had a little time to code but no time to write logs about it. Next, I`m going on holiday myself, so I won`t be coding much for the next week, if at all. 

So, as a recap, I`ve started a simple web interface, still far from all there, but at least the level diagram (board) is in place and I`m starting to get action/turn logic. It`s still far from usable, but it`s starting to come together. Hopefully a week away walking will allow me to come back to it afresh when I get back to work.

2013-09-05 - Evening
--------------------

So, I`m back in the real world, and back to work on RailsPG. There`s been a bit of idea-bashing today, and I`ve managed to make a small step forward, literally. It`s now possible to move a character one step (because his speed is 1). It`s even possible to finish your turn and then take another, so that`s a step forward.

It doesn`t currently display this movement on the spot, but that will need some re-structuring of the way level grids are rendered to actually show the path being taken (without that, I could just re-render the grid), but reloading the page shows the change. 

It`s just about starting to act like a game! The route finding work from Grid is being enacted.

