{
	title: "Post Title 1",
	body: "Body of post",
	category: "News",
	linkes: 1,
	tags: ["news", "events"],
	date: Date()
}
-----****----
create database

use blog

----****---
create collection

db.createCollection("posts")
db.posts.insertOne(object)


---****---
Insert document

insertOne()

db.posts.insertOne({
	title: "Post Title 1",
	body: "Body of post.",
	category: "News",
	links: 1,
	tags: ["news", "events"],
	date: Date()
	})

insertMany()

db.posts,insertMany([
	{
	title: "Post Title 2",
	body: "Body of post.",
	category: "Event",
	links: 2,
	tags: ["news", "events"],
	date: Date()
	},
	{
	title: "Posts Title 3",
	body: "Body of post.",
	category: "Technology",
	links: 3,
	tags: ["news", "events"],
	date: Date()
	},
	{
	title: "Post Title 4",
	body: "Body of post.",
	category: "Event",
	links: 4,
	tags: ["news", "events"],
	date: Date()
	}
	])
----****----
Find Data

// db.posts.find()
// db.posts.findOne()
// db.posts.find( {category: "News"} )
// db.posts.find({}, {title: 1, date: 1})
// db.posts.find({}, {_id: 0, title: 1, date: 1})
// db.posts.find({}, {category: 0})
// db.posts.find({}, {title: 1}, date: 0)

---****----
MongoDB update

updateOne()

db.posts.find( {title: "Post Title 1"} )
db.posts.updateOne( {title: "Post Title 1"}, { $set: {links: 2} } )
db.posts.find( { title: "Post Title 1" } )

db.posts.updateOne(
 { title: "Post Title 5"},
 {
 	$set: 
	 {
	 	title: "Post Title 5",
		body: "Body of post.",
		category: "Event",
		links: 5,
		tags: ["news", "events"],
		date: Date()
	 }
 },
 { upsert: true }
)

// updateMany()

db.posts.updateMany({}, { $inc: { links: 1 } } )

----****----
Mongo Delete

deleteOne()

db.posts.deleteOne( { title: "Post Title 5" })

deleteMany()

db.post.deleteMany({ category: "Technology" })

---***---
MongoDB Query Operators

$eq : Values are equal
$e : Values are not equal
$gt : Value is greater than another value
$gte : Value is greater than or equal to another value
$lt : Value is less than another value 
$lte : Value is less than or equal to another value 
$in : Value is matched within an array 

---***---
Logical 

$and : Retures document where both queries match
$or : Returns document where either query matches
$nor : Returns documents where both queries fail to match
$not : Returns documents where the query does not match 

---***---
Evaluation

$regex : Allows the use of regular expressions when evaluating field values
$text : Performs a text search 
$where : Uses a JavaScript expression to match documents 

---***---
Update Operators 

$currentDate : Sets the fiels value to the current date 
$inc : Increments the field value
$rename : Renames the field 
$set : Sets the value of a field 
$unset : Removes the fiels from the document 

Arrey

$addToSet : Adds distinct elements to an array
$pop : Removes the first or last element of an array
$pull : Removes all elements from an array that match the query
$push : Adds an element to an array

---***---
Aggregation Pipelines 

db.posts.aggregation([
	// Stage 1: Only Documents that have more than 1 like
	{
	 $match: { likes: { $gt:1 } }
	},
	// Stage 2: Group Documents by category and sum each categories likes 
	{
	 $group: { _id: "$category", totalLikes: { $sum: "$likes" } }
	}
	])

----***---
Aggregation $group 

_id expression provided

db.listingsAndReviews.aggregate(
 [ { $group : { _id : "$property_type"} } ]
)

$limit

db.movies.aggregate([ { $limit: 1 } ])

$project used with the find() method 

db.restaurants.aggregate([
	 {
	  $project: {
		"name": 1 ,
		"cuisine": 1,
		"address": 1	
	  }
	 },
	 {
	  $limit: 5
	 }
	])

$sort

db.listingsAndReviews.aggregate([
	{
	 $sort: { " accommodates": -1 } 
	},
	{
	 $project: {
	 	"name": 1,
		"accomodates": 1
	 }
	},
	{
	 $limit: 5
	}
	
])

$match 

db.listingsAndReviews.aggregate([
	{ $match : {{ property_type : "House" } },
	{ $limit : 2 },
	{ $project: {
			"name": 1,
		        "bedrooms": 1,
			"price": 1	
		}
	 }
	}
	])

$addFields 

db.restaurants.aggregate([
	{
	 $addFields: {
		avgGrade: { $avg: "$grades.score" }
	 }
	},
	{
	 $project: {
		"name": 1,
		"avgGrade": 1
	 }
	},
	{
	 $limit: 5
	}
	
	])

$count

db.restaurants.aggregate([
	{
	 $match: { "cuisine": "Chinese" }
	},
	{
	 $count: "totalChinese"
	}
	
	])

$lookup

from : The collection to use for lookup in the same database 
localField : The field in the primary collection that can be used as a unique identifier in the from collection.
foreignField : The field in the from collection that can be used as a unique identifier in the primary collection
as : The name of the new field that will contain the matching documents from the from collection

db.comments.aggregate([
	{
	 $lookup: {
		from: "movies",
		localField: "movie_id",
		foreignField: "_id",
		as: "movie_details",
	 },
	},
	{
	 $limit: 1
	}
])



$out

db.listingsAndReviews.aggregate([
	{
	 $group: {
	 	_id: "$property_type",
		properties: {
			$push: {
				name: "$name",
				accommodates: "$accommodate",
				price: "$price",
			},
		 },
	},
},
{ $out: "properties_by_type" },	
])

---***---
Runnig query $search

db.movies.aggregate([
	{
	 $search: {
		index: "default", // optional unless you named your index something other than "default"
		text: {
			query: "star wars",
			path: "title"
			},
		},
	},
	{
		$project: {
			title: 1,
		       year: 1,	
		}
	}
	
	])


---***---
MongoDB schema Validation

db.createCollection("posts", {
	validator: {
	 $jsonSchema: {
		bsonType: "object",
		required: [ "title", "body" ],
		properties: {
			title: {
				bsonType: "string",
				description: "Title of post - Required."
			},
			body: {
				bsonType: "string",
				description: "Body of post - Optional."
			},
			category: {
				bsonType: "string",
				description: "Category of post - Optional."
			},
			likes: {
				bsonType: "int",
				description: "Post like count. Must be a integer -Optional."
			},
			tags: {
				bsonType: "string",
				description: "Must be an array of strings - Optional."
			},
			date: {
				bsonType: "date",
				description: "Must be a date - Optional."
			}
		      }
   		 }	
 	 }
})


----***----
MongoDB data API 

sending a Data API Request 

curl --location --request POST 'https://data.mongodb-api.com/app/<DATA API APP ID>/endpoint/datav1/action/findOne' \
--header 'Content-Type: application/json' \
--header 'Access-Control-Request-Headers: *' \
--header 'api-key: <DATA API KEY>' \
--data-raw '{
	"dataSource":"<CLUSTER NAME>",
	"database":"sample_mflix",
	"collection":"movies",
	"projection": {"title": 1}
}'


---***---










