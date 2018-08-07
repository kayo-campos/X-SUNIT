# X-SUNIT

A Ruby on Rails API for an alien apocalypse.

## Problem description

All the problem specifications, as the necessarry material to solve it can be found [here](https://github.com/kimlima/gocase-backend-challenge-internship)

## How it was planned

Once upon a time I was looking for a way to make a more consistent development with a REST api approach and a client to consume this api and found a very interesting idea: you should start by making sure your api is consistent, then you move to the client-side. Later, reading [How to Design Programs](https://htdp.org), I found another interesting conecpt: programs treat real world information as data, so you should start by planning how to represent information in a computational world. With these two concepts in mind, first thing done was defining models, which makes it possible that the api is consistent.

### Defining Models

At first, I had the following models:

![first database models](https://raw.githubusercontent.com/PuckmanXY/X-SUNIT/master/first_model_diagram.png)

Two models were everything I needed to represent all the information the problem wanted. It became a problem when I realized updating a survivor location and updating a survivor information isn't the same thing to the problem (keep in mind that the real-world-information-as-data thing also applies to real world actions and functions/methods/routines - their representations in a computational world). The solution was clear: create a model to locations. 
![final database models](https://raw.githubusercontent.com/PuckmanXY/X-SUNIT/master/final_model_diagram.png)

### Adapting to REST pattern

Building a REST api is quite a nice way to organize the backend routes. Since I already implemented a few similar things in NodeJS, coming up with the REST way to organize routes was quite simple. Basically, accessing a '/survivors' route should give access to the survivors models, then '/survivors/:id/location' should be related to location model and '/survivors/:id/abduction_reports' should give access to abduction report model. At first, I tried several times to define these routes by hand just the way I used to do in NodeJS, then the whole "Convention Over Configuration" of Rails made the job quite easier (at least when I understood how it works, which took a few commits and several documentation readings).

### Learning Ruby on Rails

No, I never worked with Ruby nor Ruby on Rails before. The challenge repository contained the necessarry material to do it, so it helped me a lot. Also, I watched a few videos as the [One bit code ruby course](https://www.youtube.com/watch?v=2js9Q_BMD-8&list=PLdDT8if5attEOcQGPHLNIfnSFiJHhGDOZ) and took a look at several articles I found googling arround, and of course, a few StackOverflow questions.

## How it was coded

If RoR says "Convention over Configuration", who am I to say the opposite? Having everything planned, it was ok to wrap everything up. I took some precautions about some of the use cases I could find, which are described below.

### The survivors abduction

To report an abduction, a survivor and a witness are required, as a few things need to be validated (and you can find everything well explained in the body of the functions in [abduction_reports_controller.rb](app/controllers/api/v1/abduction_reports_controller.rb)):

1. Do the survivors involved in an abduction report acctually exist?
2. Are the witness and the survivor different people?
3. Is it the first time this witness is reporting this abduction?

If the answer to all these questions is "yes", then it's ok to report this abduction. And at last, if the survivor has been reported as abducted at least three times AND this information isn't in the database already, then he should be flagged as abducted.

With this planned, coding it became easier.

### Updating a survivor location

At first, I tried to define the route for this by hand since I wasn't used to the Convention over Configuration philosophy. Then I found out that writing "resource" instead of "resources" in [routes.rb](config/routes.rb) was just what I was looking for.

### Listing resources

For getting the percentages requested, I scoped the abducted and non_abducted survivors in my [survivors.rd](app/models/survivor), which generates an ActiveRecord::Relation, and I'm quite sure rails takes care of caching it, so I don't have to worry that much about performance here, rails will do the trick.

## Ok, but how do I use it?

I plan on deploying it, but if you can't wait for an alien apocalypse, then you may try:

1. Clone the repository
    
    $ git clone https://github.com/puckmanxy/x-sunit

2. Install dependencies

    $ bundle install

3. Run migrations

    $ rake db:migrate

4. In the folder you cloned the repository, type:

    $ rails s

Then go to next section and try it.
OBS - I strongly suggest you test it with Postman or Insomnia or whatever you may want to use for testing apis.

## And what about using the API?

I tried to strictly follow the REST pattern, so, in topics:

### Survivors

Route '/api/v1/survivors' gives access to a CRUD in survivors model, following REST pattern as said, so:

    GET /api/v1/survivors

returns response.data.survivors, an array of survivors sorted by name

    POST /api/v1/survivors

allow you to insert a new survivor to the database, as long as you pass a JSON following the example:

    {
        "name": "Jhon",
        "age": 24,
        "gender": "m",
        "latitude": 58.9356,
        "longitude": -32.0967
    }

Now, to edit a survivor

    UPDATE /api/v1/survivors/:id

let you update survivor with the informed id information, since you pass a JSON with name and/or age and/or gender. Updating a survivor location can be found in location section.

    DELETE /api/v1/survivors/:id

deletes the survivor with the informed id, all related information in other tables (location and abduction reports).

### Locations

A location is a survivor atribute, so:

    GET /api/v1/survivors/:survivor_id/location

returns response.data.location with the the needed information about the survivor location

    UPDATE /api/v1/survivors/:survivor_id/location

updates the survivor - referenced by id - location as long as a JSON containing the new latitude and longitude is passed in the body of requisition.

### Abduction Reports

To report a survivor as abducted, the route is:

    POST /api/v1/survivors/:survivor_id/abduction_reports

the witness must send a JSON containing its id in the body of the requisition, like this:

    {
        "witness_id": 3
    }

### General information

Say you just want to know about quantities and percentages and not to worry about names, ages or locations. We cover you, just get the endpoint

    GET /api/v1/general-information

and you have the needed information in response.data.

## And about the avaliation?

Well, this challenge really made me try my best. I spent hours learning how to do stuff in a language I never used before and I'm really into Rails, even with a node-mind, it wasn't that hard to code this, since Rails really helps the programmer.

At first, I was excited about the new language, so I assume I made some mistakes when modeling database, but it was necessarry, 'cause I could see that if a database isn't well defined, then a whole system may get structure problems. The most important point about doing this was how to model things... Learning to code in Rails came naturally as I needed to implement things, and I'm really satisfied about it.
