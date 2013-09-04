# zJSON
The JSON Document Class
 
* Nugget: NUGG_JSON_PARSER.x.x.x.nugg
 
## Required Packages
None
 
## Usage (Release 0.2.x)
 
Creating a JSON document with ABAP data (you can pass any structure/table/complex data, except objects)
 
``` 
SELECT * FROM scarr
   INTO TABLE scarr_t
   UP TO 3 ROWS.

json_doc = zcl_json_document=>create_with_data( scarr_t ).
json = json_doc->get_json( ).
```
 
String "json" now contains:
``` 
[
{
"mandt" :"001",
"carrid" :"AA",
"carrname" :"American Airlines",
"currcode" :"USD",
"url" :"http://www.aa.com"
},
{
"mandt" :"001",
"carrid" :"AB",
"carrname" :"Air Berlin",
"currcode" :"EUR",
"url" :"http://www.airberlin.de"
},
{
"mandt" :"001",
"carrid" :"AC",
"carrname" :"Air Canada",
"currcode" :"CAD",
"url" :"http://www.aircanada.ca"
}
]
```
 
## New in release 0.2.13
if you are expecting a large JSON string, please use the following code to prevent unneccessary memory consumption ("call by ref" instead of "call by value")
 
``` 
	json_doc->get_json_large(
  	IMPORTING
    	json = json
	).
```
 
Creating a JSON document with JSON data and read content (array in this case)

``` 
json_doc = zcl_json_document=>create_with_json( json ).

WHILE json_doc->get_next( ) IS NOT INITIAL.

   carrid = json_doc->get_value( 'carrid' ).
   carrname = json_doc->get_value( 'carrname' ).

   WRITE:/ carrid, carrname.

ENDWHILE.
```
 
## Working with nested arrays/tables (new in version 0.2.10)
 
Please note: the JSON document class is only able to keep one array and one JSON data string in memory. If you have to parse a nested array, you need one JSON class instance per nested array.
 
``` 
lv_json = '[[123,"abc"],[456,"def","another one"]]'.
lo_json_doc = zcl_json_document=>create_with_json( json = lv_json ).
 
WHILE lo_json_doc->get_next( ) IS NOT INITIAL.
   	lo_json_doc2 = zcl_json_document=>create_with_json( json = lo_json_doc->get_json( ) ).
 
   	WHILE lo_json_doc2->get_next( ) IS NOT INITIAL.
     	lv_json = lo_json_doc2->get_json( ).
     	WRITE:/ lv_json.
   	ENDWHILE.
 
ENDWHILE.
```
 
## New in version 0.2.1
 
Append multiple data objects:

``` 
SELECT SINGLE * FROM mara
   INTO mara_data
   WHERE matnr = '100-100'.

SELECT * FROM marc
   INTO TABLE marc_data_t
   WHERE matnr = '100-100'.

json_doc = zcl_json_document=>create( ).
json_doc->append_data( data = mara_data iv_name = 'MARA' ).
json_doc->append_data( data = marc_data_t iv_name = 'MARC' ).
json = json_doc->get_json( ).
```
 
Result

```
{
"MARA":
{
"mandt" :"800",
"matnr" :"100-100",
"ersda" :"19941107",
"ernam" :"BALLER",
..
"fiber_part5" :"000",
"fashgrd" :""
},
"MARC":
[
{
"mandt" :"800",
"matnr" :"100-100",
"werks" :"1000",
"pstat" :"VEDPALSQGF",
..
"ref_schema" :"",
"min_troc" :"000",
"max_troc" :"000",
"target_stock" :0.000
}
]
}
```
 
## New in version 0.2.3
 
Get ABAP data object from JSON string:
 
Assume our JSON contains the following data (a structure object and a table)
```
{
"scarr" :
{"mandt" :"001",
"carrid" :"LH",
"carrname" :"Lufthansa",
"currcode" :"EUR",
"url" :"http://www.lufthansa.com"
},
"sflight" :
[{"mandt" :"001",
"carrid" :"LH",
"connid" :"0400",
"fldate" :"20100821",
...
"seatsocc_f" :10},
{"mandt" :"001",
"carrid" :"LH",
"connid" :"0400",
"fldate" :"20100918",
...
"seatsocc_f" :10}
]
}
``` 

Create the JSON document class as always

``` 
json_doc = zcl_json_document=>create_with_json( json ).
``` 

Now get the ABAP data object

``` 
TYPES: BEGIN OF ts_data,
     	scarr TYPE scarr,
     	sflight TYPE flighttab,
   	END OF ts_data.

DATA: ls_data TYPE ts_data.

json_doc->get_data( IMPORTING data = ls_data ).
``` 

## New in version 0.2.6

Formated output of a JSON string (for test purposes)

``` 
json_doc = zcl_json_document=>create_with_data( scarr_t ).
json_doc->dumps( IMPORTING result = result ).LOOP AT result
  ASSIGNING <line>.
  WRITE:/ <line>.
ENDLOOP.
```
 
Output
 
``` 
{
	"itab" :
	[
    	{
        	"mandt" : 001,
        	"carrid" : "AA",
        	"carrname" : "American Airlines",
        	"currcode" : "USD",
        	"url" : "http://www.aa.com"
    	},
    	{
        	"mandt" : 001,
        	"carrid" : "AB",
        	"carrname" : "Air Berlin",
        	"currcode" : "EUR",
        	"url" : "http://www.airberlin.de"
    	},
    	{
        	"mandt" : 001,
        	"carrid" : "AC",
        	"carrname" : "Air Canada",
        	"currcode" : "CAD",
        	"url" : "http://www.aircanada.ca"
    	}
	]
}
```
 
## New in version 0.2.9

Same example as above, but creation of JSON without "itab".

``` 
json_doc = zcl_json_document=>create_with_data(
  data          = scarr_t
  suppress_itab = abap_true ).
```
 
The result is now:
 
``` 
[
	{
    	"mandt" : "001",
    	"carrid" : "AA",
    	"carrname" : "American Airlines",
    	"currcode" : "USD",
    	"url" : "http://www.aa.com"
	},
	{
    	"mandt" : "001",
    	"carrid" : "AB",
    	"carrname" : "Air Berlin",
    	"currcode" : "EUR",
    	"url" : "http://www.airberlin.de"
	},
	{
    	"mandt" : "001",
    	"carrid" : "AC",
    	"carrname" : "Air Canada",
    	"currcode" : "CAD",
    	"url" : "http://www.aircanada.ca"
	}
]
```
 
## Working with conversion exits (new in Release 0.2.14)
 
``` 
	TYPES: BEGIN OF ts_x,
         	field TYPE spras,
       	END OF ts_x.

	ls_x-field = 'S'.	"Spanish

	json_doc->set_use_conversion_exit( abap_false ).   "default
	json_doc->set_data( ls_x ).
	json = json_doc->get_json( ).
```

Result {"field" :"S"}

```
	json_doc->set_use_conversion_exit( abap_true ).
	json_doc->set_data( ls_x ).
	json = json_doc->get_json( ).
```
	
Result {"field" :"ES"}

``` 
	json = '{"field" :"S"}'.
	json_doc->set_use_conversion_exit( abap_false ).   "default
	json_doc->set_json( json ).
	json_doc->get_data(
  	IMPORTING
    	data = ls_x
	).
```
 
Result ls-x = 'S'
 
``` 
	json = '{"field" :"ES"}'.
	json_doc->set_use_conversion_exit( abap_true ).
	json_doc->set_json( json ).
	json_doc->get_data(
  	IMPORTING
    	data = ls_x
	).
``` 
 
Result ls-x = 'S'
 
## Simple transformation (new in Release 0.2.17)

Starting with Basis Release 7.02 SP11 (other Releases: see SAP note 1648418) and Kernel Release 720 patch 116 it is possible to parse JSON with SAP standard transformation. If you don't need special features of the JSON document class (ie. date format, conversion exits) you can use a new class method to convert JSON to ABAP data and vice versa (better performance and less memory consumption).
 
``` 
	TYPES: BEGIN OF ts_test,
         	s TYPE string,
         	d type d,
       	END OF ts_test.
 
    DATA json 	TYPE string.
	DATA test TYPE ts_test.
 
	"*--- ABAP -> JSON ---*
	test-s = 'aaa " bbb \ ccc < ddd > eee'.
	test-d = sy-datlo.
 
	zcl_json_document=>transform_simple(
  	EXPORTING
    	data_in  = test
  	IMPORTING
    	json_out = json
	).
 
	WRITE:/ json.
```
	
"-> {"RESULT":{"S":"aaa \" bbb \\ ccc < ddd > eee","D":"2013-02-01"}}

``` 
	"*--- JSON -> ABAP ---*
	CLEAR test.
 
	zcl_json_document=>transform_simple(
  	EXPORTING
    	json_in  = json
  	IMPORTING
    	data_out = test
	).
 
	WRITE:/ test-s, test-d.
```
	
"-> aaa " bbb \ ccc < ddd > eee 01022013

