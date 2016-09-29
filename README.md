# [ DailyDrip Pairing 004.1 (Elm)] Josh Adams and Corey Haines - Game of Life Parser

This is the repo from the pairing session mentioned below.  It's where I learned
how [elm-combine](http://github.com/Bogdanp/elm-combine) works.  [I posted about
it on Medium as well.](https://medium.com/@dailydrip/josh-adams-and-corey-haines-pair-programming-and-test-driving-a-game-of-life-parser-in-elm-176487214f2d#.7goxqt3zp)

---

In this pairing session from [DailyDrip](http://www.dailydrip.com), [Josh
Adams](http://twitter.com/knewter) and [Corey
Haines](http://twitter.com/coreyhaines) work through building a parser (driven
by tests) for RLE-encoded Game of Life files, using
[elm-combine](http://github.com/Bogdanp/elm-combine).  A tiny stack machine is
introduced for handling repeats as well, though in reality it could likely have
been solved without that.

<iframe width="560" height="315" src="https://www.youtube.com/embed/7SacmHT7lLc" frameborder="0" allowfullscreen></iframe>

The code we ended up with is available [on the `knewter/combine-playground`
repo](https://github.com/knewter/combine-playground) on GitHub.

It's a very lengthy pairing session - **2 hours and 11 minutes**.  With that in
mind, here's a rough outline of various timings in the video:

- 00:00:13 - A rapid introduction to elm-combine.  I worked with it for an hour
  or so before we got started, and I just kind of speed through what I've
  learned so far.
- 00:03:58 - We burn a few minutes figuring out what these files are even called
  and where they're located and what the format's called :) Hint: Run-Length
  Encoded, and the format's described [here](http://psoup.math.wisc.edu/mcell/ca_files_formats.html#RLE).
- 00:29:25 - This is where I decided, for better or for worse, that I'd solve
  the 'repeat' instruction by making a single-instruction stack machine, though
  we don't actually get to that for another 20 minutes or so.
- 01:19:23 - We could parse lines but here we started figuring out how to turn
  the list of lines into a list of another type that we could use for the rest
  of the program, and it took us quite a while.  What's worse, Bogdan has
  confirmed that we did this kind of dumb (we had an inkling).  But we got it
  working!
- 01:52:24 - We integrate it into my existing game of life engine and try a
  couple of patterns on for size.

**NOTE:** I love doing these.  It's also kind of my job (best job ever) as a
co-founder of DailyDrip.  If you enjoy this maybe consider signing up for
[DailyDrip](https://www.dailydrip.com), as that's what helps me have the time and
obligation to put this stuff out there.  If you don't enjoy it, I'm sorry you
have bad taste! :) :) :)

Do you have ideas for another pairing session I should do?  Interested in
setting one up with me?  That's what the comments are for!
