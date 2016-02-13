<p align="center">
  <img src="http://puu.sh/n5TNe/a5e7bc8208.png" height="200" width="200" />
</p>

# osu!replay

## What is it?

It's a simple website where you can upload your osu! replays and share them. As a bonus, you get a pretty page where most of the informations on the replay are listed (See a bit below for an example of what might be displayed on the page).

## Where do I see it?

The website is deployed frequently on [Heroku](osu-replay.herokuapp.com) though it's pretty much in development and replays might be wiped sometimes.

## How do I build it?

To build the website, you will need:

- [Node.js](https:#nodejs.org) installed on your machine

If you plan on testing the production version of the website, you will need:

- A [MongoDB](https:#www.mongodb.org/) server running somewhere
- An [Amazon S3](https:#aws.amazon.com/s3/) access key

Though if you just want to test the front-end, the website will use local storages (That will be wiped at each restart, so be careful).

Don't forget to put the Node.js executable in your PATH, so you can run in a console:

    node --version

Once everything is installed, and correctly in your PATH:

    # Clone the repository
    git clone https:#github.com/Soinou/osu-replay
    # Move into the directory
    cd osu-replay
    # Install all npm dependencies
    npm install
    # Run the server the first time
    npm start

The first time the server is started, it will ask you to setup the .env file. This file will be at the root of the directory.

All the informations on this file are contained inside it, please have a look at it and fill informations accordingly. Of course, MongoDB and Amazon S3 informations are only needed if you wish to run the production version of the website.

Once the .env file is correctly filled, you can rerun the server again:

    npm start

And now it should launch and you will be able to access the website in your browser.

## How do I run the tests?

To run the tests you need to install the npm dev dependencies. You need to have the NODE_ENV environment variable set as anything other than "production", then run:

    npm install

It will then install [mocha](mochajs.org) and [chai](chaijs.com). Finally, you will be able to run:

    npm test

And the tests will run. You can disable some of the tests in the .env file, and configure some others in this same file, since this file is loaded before all the tests are run.

## Example of how the replays look like

This is the data format of the osu! replays the front-end is getting. If you have some ideas on how to use some of these fields, please feel free to tell us!

```
{
    # Internal replay id, used as Amazon S3 key and a few other things
    "_id": "7fe1e42868adb82f434f50d6ca413cc7",
    # Replay title
    "title": "Replay Title",
    # Replay description
    "description": "Replay Description",
    # Replay timestamp (In Windows ticks)
    "timestamp": "5646369965869159000",
    # Game mods (As a bitwise enum)
    "mods": "2",
    # If the play is a full combo (1) or not (0)
    "perfect": "0",
    # The max combo
    "combo": "227",
    # The total score
    "score": "715344",
    # The number of misses
    "misses": "15",
    # The number of katus
    "katus": "9",
    # The number of gekis
    "gekis": "103",
    # The number of 50
    "n_50": "0",
    # The number of 100
    "n_100": "20",
    # The number of 300
    "n_300": "377",
    # The replay hash
    "hash": "2beda44cb97b6c32f49155ff931b015b",
    # The game version at the time the play was done
    "version": "20151228",
    # The played game mode
    "mode": "0",
    # The replay file link on Amazon S3 (This one will probably not work)
    "link": "http:#osu-replay.s3.amazonaws.com/99518e06b783f76c2da9cafb30b15d9d.osr",
    # The player (Replaced from the player name to the player from the osu!api)
    "player":
    {
        # Id to store the player in the database (Actually player name)
        "_id": "Musty",
        "user_id": "251683",
        "username": "Musty",
        "count300": "14551965",
        "count100": "1019704",
        "count50": "135259",
        "playcount": "82829",
        "ranked_score": "32712040990",
        "total_score": "163550416215",
        "pp_rank": "31",
        "level": "101.366",
        "pp_raw": "8904.25",
        "accuracy": "99.23434448242188",
        "count_rank_ss": "91",
        "count_rank_s": "1480",
        "count_rank_a": "1084",
        "country": "FR",
        "pp_country_rank": "2",
        "events": [ "..." ]
    },
    # The replay beatmap (Replace from the beatmap md5 to the beatmap from the osu!api)
    "beatmap":
    {
        # Id to store the beatmap in the database (Actually file md5)
        "_id": "81c46158adfb2a23b92aa472e5470cc8",
        "beatmapset_id": "10112",
        "beatmap_id": "40017",
        "approved": "1",
        "total_length": "77",
        "hit_length": "77",
        "version": "Oni",
        "file_md5": "81c46158adfb2a23b92aa472e5470cc8",
        "diff_size": "4",
        "diff_overall": "8",
        "diff_approach": "8",
        "diff_drain": "6",
        "mode": "0",
        "approved_date": "2009-11-08 22:20:09",
        "last_update": "2009-11-08 22:14:51",
        "artist": "Niko",
        "title": "Made of Fire",
        "creator": "lesjuh",
        "bpm": "163",
        "source": "",
        "tags": "insane stepmania gladi gladiool",
        "genre_id": "2",
        "language_id": "2",
        "favourite_count": "190",
        "playcount": "627072",
        "passcount": "58995",
        "max_combo": "531",
        "difficultyrating": "5.430817604064941"
    }
}
```

## License

License (WTFPL) is provided in the [LICENSE.md](https:#github.com/Soinou/osu-replay/blob/master/LICENSE.md) file.
