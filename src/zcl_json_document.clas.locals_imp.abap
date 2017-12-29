*"* local class implementation for public class
*"* use this source file for the implementation part of
*"* local helper classes
TYPES: BEGIN OF t_int,
         i TYPE i,
       END OF t_int,
       BEGIN OF t_packed,
         p TYPE p LENGTH 10 DECIMALS 2,
       END OF t_packed,
       BEGIN OF t_numc,
         nc TYPE n LENGTH 4,
       END OF t_numc,
       BEGIN OF t_string,
         s TYPE string,
       END OF t_string,
       BEGIN OF t_struc1,
         i   TYPE i,
         nc  TYPE n LENGTH 4,
         p   TYPE p LENGTH 10 DECIMALS 2,
         s   TYPE string,
         c1  TYPE c LENGTH 1,
         c20 TYPE c LENGTH 20,
         x   TYPE xstring,
         dr  TYPE REF TO data,
       END OF t_struc1,
       BEGIN OF t_date,
         d TYPE d,
       END OF t_date,
       BEGIN OF t_namespace,
         /cex/test TYPE string,
         test      TYPE string,
       END OF t_namespace.

*----------------------------------------------------------------------*
*       CLASS lcl_zjson DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_zjson DEFINITION FINAL FOR TESTING "#AU Risk_Level Harmless
.                                            "#AU Duration   Short
*  DURATION SHORT          ">= 7.02
*  RISK LEVEL HARMLESS.    ">= 7.02

  PRIVATE SECTION.
    DATA: json_doc  TYPE REF TO zcl_json_document,
          json_doc2 TYPE REF TO zcl_json_document,
          json_str  TYPE string.

    METHODS: test_number              FOR TESTING
      RAISING
        zcx_json_document,
      test_string_number       FOR TESTING
        RAISING
          zcx_json_document,
      test_string_escape       FOR TESTING,
      test_string_number_struc FOR TESTING
        RAISING
          zcx_json_document,
      test_xstring             FOR TESTING
        RAISING
          zcx_json_document,
      test_dref                FOR TESTING
        RAISING
          zcx_json_document,
      test_number_struct       FOR TESTING
        RAISING
          zcx_json_document,
      test_append_data         FOR TESTING,
      test_string_table        FOR TESTING
        RAISING
          zcx_json_document,
      test_stru_table          FOR TESTING
        RAISING
          zcx_json_document,
      test_stru_table_named    FOR TESTING,
      test_parse_list_strings  FOR TESTING,
      test_parse_flat_object   FOR TESTING
        RAISING
          zcx_json_document,
      test_date_format         FOR TESTING,
      test_date_format_reverse FOR TESTING
        RAISING
          zcx_json_document,
      test_namespace           FOR TESTING,
      test_boolean             FOR TESTING
        RAISING
          zcx_json_document,
      test_transform_simple    FOR TESTING
        RAISING
          zcx_json_document
          cx_xslt_format_error,
      test_name_values         FOR TESTING
        RAISING
          zcx_json_document.

ENDCLASS.                    "lcl_zjson DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_zjson IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_zjson IMPLEMENTATION.

  METHOD test_number.
    DATA: tpacked  TYPE p LENGTH 10 DECIMALS 2,
          tpacked2 TYPE p LENGTH 10 DECIMALS 2,
          tfloat   TYPE f,
          tint     TYPE i,
          tint2    TYPE i,
          tnumc    TYPE n LENGTH 4,
          tnumc2   TYPE n LENGTH 4.

*   packed number
    tfloat = '10.5'.
    tpacked = tfloat.  "conversion to packed
    json_doc = zcl_json_document=>create_with_data( tpacked ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '10.50'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = tpacked2 ).
    cl_aunit_assert=>assert_equals( exp = tpacked
                                    act = tpacked2 ).

*   packed negative
    tfloat = '-999.55'.
    tpacked = tfloat.  "conversion to packed
    json_doc = zcl_json_document=>create_with_data( tpacked ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '-999.55'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = tpacked2 ).
    cl_aunit_assert=>assert_equals( exp = tpacked
                                    act = tpacked2 ).


*   integer
    tint = 10.
    json_doc = zcl_json_document=>create_with_data( tint ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '10'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = tint2 ).
    cl_aunit_assert=>assert_equals( exp = tint
                                    act = tint2 ).

*   numc
    tnumc = '00010'.
    json_doc = zcl_json_document=>create_with_data( tnumc ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '"0010"'
                                    act = json_str ).

    json_doc = zcl_json_document=>create_with_data(
               data             = tnumc
               numc_as_numeric  = abap_true
           ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '10'
                                    act = json_str ).

    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = tnumc2 ).
    cl_aunit_assert=>assert_equals( exp = tnumc
                                    act = tnumc2 ).

*   numc with just zeros
    tnumc = '00000'.
    json_doc = zcl_json_document=>create_with_data( tnumc ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '"0000"'
                                    act = json_str ).

    json_doc = zcl_json_document=>create_with_data(
               data             = tnumc
               numc_as_numeric  = abap_true
           ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '0'
                                    act = json_str ).

    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = tnumc2 ).
    cl_aunit_assert=>assert_equals( exp = tnumc
                                    act = tnumc2 ).

  ENDMETHOD.                    "test_number


  METHOD test_string_number.
    DATA: t_str  TYPE string,
          t_str2 TYPE string.

    t_str = '0010'.
    json_doc = zcl_json_document=>create_with_data( t_str ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '"0010"'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = t_str2 ).
    cl_aunit_assert=>assert_equals( exp = t_str
                                    act = t_str2 ).

  ENDMETHOD.                    "test_string_number

  METHOD test_string_escape.

    DATA: BEGIN OF t_struc,
            abc TYPE string VALUE 'def:"123}',
          END OF t_struc.
    DATA t_str TYPE string.

    json_doc = zcl_json_document=>create_with_data( t_struc ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"abc" :"def:\"123}"}'
                                    act = json_str ).

    json_doc = zcl_json_document=>create_with_json( json_str ).
    t_str = json_doc->get_value( 'abc' ).

    cl_aunit_assert=>assert_equals( exp = 'def:\"123}'
                                    act = t_str ).

  ENDMETHOD.                    "test_string_number


  METHOD test_string_number_struc.
    DATA: s_str  TYPE t_string,
          s_str2 TYPE t_string.

    s_str-s = '0010'.
    json_doc = zcl_json_document=>create_with_data( s_str ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"s" :"0010"}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_str2 ).
    cl_aunit_assert=>assert_equals( exp = s_str
                                    act = s_str2 ).
  ENDMETHOD.                    "test_string_number_struc


  METHOD test_string_table.
    DATA: str     TYPE string,
          strtab  TYPE TABLE OF string,
          strtab2 TYPE TABLE OF string.

    str = '0010'. APPEND str TO strtab.
    str = '0020'. APPEND str TO strtab.
    str = '0030'. APPEND str TO strtab.

    json_doc = zcl_json_document=>create_with_data( data = strtab suppress_itab = 'X' ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '["0010","0020","0030"]'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = strtab2 ).
    cl_aunit_assert=>assert_equals( exp = strtab
                                    act = strtab2 ).

  ENDMETHOD.                    "test_string_table


  METHOD test_number_struct.
    DATA: tfloat    TYPE f,
          s_int     TYPE t_int,
          s_int2    TYPE t_int,
          s_packed  TYPE t_packed,
          s_packed2 TYPE t_packed,
          s_numc    TYPE t_numc,
          s_numc2   TYPE t_numc.

*   Integer
    s_int-i = 10.
    json_doc = zcl_json_document=>create_with_data( s_int ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"i" :10}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_int2 ).
    cl_aunit_assert=>assert_equals( exp = s_int
                                    act = s_int2 ).

*   Packed number
    tfloat = '10.5'.
    s_packed-p = tfloat.  "conversion
    json_doc = zcl_json_document=>create_with_data( s_packed ).
    json_str = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"p" :10.50}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_packed2 ).
    cl_aunit_assert=>assert_equals( exp = s_packed
                                    act = s_packed2 ).

*   NUMC without leading zeros
    s_numc-nc = '10'.
    json_doc = zcl_json_document=>create_with_data( s_numc ).
    json_str = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"nc" :"0010"}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_numc2 ).
    cl_aunit_assert=>assert_equals( exp = s_numc
                                    act = s_numc2 ).

    json_doc = zcl_json_document=>create_with_data(
               data             = s_numc
               numc_as_numeric  = abap_true
           ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"nc" :10}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_numc2 ).
    cl_aunit_assert=>assert_equals( exp = s_numc
                                    act = s_numc2 ).

*   NUMC with leading zeros
    s_numc-nc = '0010'.
    json_doc = zcl_json_document=>create_with_data( s_numc ).
    json_str = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"nc" :"0010"}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_numc2 ).
    cl_aunit_assert=>assert_equals( exp = s_numc
                                    act = s_numc2 ).

    json_doc = zcl_json_document=>create_with_data(
               data             = s_numc
               numc_as_numeric  = abap_true
           ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"nc" :10}'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = s_numc2 ).
    cl_aunit_assert=>assert_equals( exp = s_numc
                                    act = s_numc2 ).

  ENDMETHOD.                    "test_number_struct


  METHOD test_append_data.
    DATA: s_int    TYPE t_int,
          s_string TYPE t_string.

    s_int-i = 10.
    s_string-s = 'abc'.

    json_doc = zcl_json_document=>create( ).
    json_doc->append_data( data = s_int iv_name = 's_int' ).
    json_doc->append_data( data = s_string iv_name = 's_string' ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals(
        exp = '{"s_int":{"i" :10}, "s_string":{"s" :"abc"}}'
        act = json_str ).

  ENDMETHOD.                    "test_append_data

  METHOD test_stru_table.

    DATA: str     TYPE t_string,
          strtab  TYPE TABLE OF t_string,
          strtab2 TYPE TABLE OF t_string.

    str-s = '0010'. APPEND str TO strtab.
    str-s = '00xx'. APPEND str TO strtab.
    str-s = '0030'. APPEND str TO strtab.

    json_doc = zcl_json_document=>create_with_data( data = strtab suppress_itab = 'X' ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '[{"s" :"0010"},{"s" :"00xx"},{"s" :"0030"}]'
                                    act = json_str ).
    json_doc2 = zcl_json_document=>create_with_json( json_str ).
    json_doc2->get_data( IMPORTING data = strtab2 ).
    cl_aunit_assert=>assert_equals( exp = strtab
                                    act = strtab2 ).

  ENDMETHOD.                    "test_stru_table

  METHOD test_stru_table_named.

    DATA: str     TYPE t_string,
          strtab  TYPE TABLE OF t_string,
          strtab2 TYPE TABLE OF t_string.

    str-s = '0010'. APPEND str TO strtab.
    str-s = '00xx'. APPEND str TO strtab.
    str-s = '0030'. APPEND str TO strtab.

    json_doc = zcl_json_document=>create( ).
    json_doc->append_data( data = strtab
                           iv_name = 'dataname' ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"dataname": [{"s" :"0010"},{"s" :"00xx"},{"s" :"0030"}]}'
                                    act = json_str ).

  ENDMETHOD.                    "test_stru_table_named

  METHOD test_parse_list_strings.
    DATA: json_input TYPE string,
          has_next   TYPE boolean.

    json_input = '["value1","value2","value3"]'.
    json_doc = zcl_json_document=>create_with_json( json_input ).
    json_doc->get_next( ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = 'value1'
                                    act = json_str ).
    json_doc->get_next( ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = 'value2'
                                    act = json_str ).
    json_doc->get_next( ).
    json_str = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = 'value3'
                                    act = json_str ).
    has_next = json_doc->get_next( ).
    cl_aunit_assert=>assert_equals( exp = ''
                                    act = has_next ).
  ENDMETHOD.                    "test_parse_list_strings

  METHOD test_parse_flat_object.
    DATA: json_input TYPE string,
          input_stru TYPE t_struc1,
          ref_stru   TYPE t_struc1.

    json_input = '{"i":22,"nc":20,"c1":"X","c20":"test","s":"string test","p":20.5}'.
    ref_stru-i = 22.
    ref_stru-nc = 20.
    ref_stru-c1 = 'X'.
    ref_stru-c20 = 'test'.
    ref_stru-s = 'string test'.
    ref_stru-p = '20.5'.

    json_doc = zcl_json_document=>create_with_json( json_input ).
    json_doc->get_data( IMPORTING data = input_stru ).

    cl_aunit_assert=>assert_equals( exp = ref_stru
                                    act = input_stru ).

    "test starting from a structure and getting the structure in the end
    CLEAR input_stru.
    json_doc = zcl_json_document=>create_with_data( ref_stru ).
    json_doc->get_data( IMPORTING data = input_stru ).

    cl_aunit_assert=>assert_equals( exp = ref_stru
                                    act = input_stru ).

  ENDMETHOD.                    "test_parse_flat_object

  METHOD test_date_format.

    DATA input_stru TYPE t_date.
    DATA ref_stru   TYPE t_date.
    DATA json       TYPE string.

    input_stru-d = '20120927'.
    json_doc = zcl_json_document=>create( ).

    "*--- test standard JSON date format ---*
    json_doc->set_data( input_stru ).
    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"d" :"20120927"}'
                                    act = json ).

    "*--- test SUP date format ---*
    json_doc->set_data(
        data          = input_stru
        date_format   = 'YYYY-MM-DD'
    ).

    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"d" :"2012-09-27"}'
                                    act = json ).

    "*--- test world date format ---*
    json_doc->set_data(
        data          = input_stru
        date_format   = 'DD.MM.YYYY'
    ).

    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"d" :"27.09.2012"}'
                                    act = json ).

    "*--- test US date format ---*
    json_doc->set_data(
        data          = input_stru
        date_format   = 'MM/DD/YYYY'
    ).

    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"d" :"09/27/2012"}'
                                    act = json ).

    "*--- test short date format ---*
    json_doc->set_data(
        data          = input_stru
        date_format   = 'DDMMYY'
    ).

    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"d" :"270912"}'
                                    act = json ).

  ENDMETHOD.                    "test_date_format

  METHOD test_date_format_reverse.

    DATA input_stru TYPE t_date.
    DATA ref_stru   TYPE t_date.
    DATA json       TYPE string.

    input_stru-d = '20120927'.
    json_doc = zcl_json_document=>create( ).

    "*--- test standard JSON date format ---*
    json = '{"d" :"20120927"}'.
    json_doc->set_json( json ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    cl_aunit_assert=>assert_equals( exp = input_stru
                                    act = ref_stru ).

    "*--- test SUP date format ---*
    json = '{"d" :"2012-09-27"}'.
    json_doc->set_json(
      EXPORTING
        json        = json
        date_format = 'YYYY-MM-DD'
    ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    cl_aunit_assert=>assert_equals( exp = input_stru
                                    act = ref_stru ).

    "*--- test world date format ---*
    json = '{"d" :"27.09.2012"}'.
    json_doc->set_json(
      EXPORTING
        json        = json
        date_format = 'DD.MM.YYYY'
    ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    cl_aunit_assert=>assert_equals( exp = input_stru
                                    act = ref_stru ).

    "*--- test US date format ---*
    json = '{"d" :"09/27/2012"}'.
    json_doc->set_json(
      EXPORTING
        json        = json
        date_format = 'MM/DD/YYYY'
    ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    cl_aunit_assert=>assert_equals( exp = input_stru
                                    act = ref_stru ).


  ENDMETHOD.                    "test_date_format_reverse

  METHOD test_namespace.

    DATA input_stru TYPE t_namespace.
    DATA json       TYPE string.

    input_stru-/cex/test = 'with namespace'.
    input_stru-test = 'without namespace'.

    json_doc = zcl_json_document=>create( ).

    "*--- regular namespace ---*
    json_doc->set_data( input_stru ).
    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"/cex/test" :"with namespace","test" :"without namespace"}'
                                    act = json ).

    "*--- replace namespace ---*
    json_doc->set_namespace_conversion(
      EXPORTING
        namespace_1_slash_replace = ''
        namespace_2_slash_replace = '_'
    ).

    json_doc->set_data( input_stru ).
    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"cex_test" :"with namespace","test" :"without namespace"}'
                                    act = json ).

  ENDMETHOD.                    "test_namespace


  METHOD test_xstring.

    DATA input_stru TYPE t_struc1.
    DATA ref_stru   TYPE t_struc1.
    DATA json       TYPE string.

    input_stru-x = '00AABB'.
    json_doc = zcl_json_document=>create_with_data( input_stru ).

    json = json_doc->get_json( ).

    json_doc->set_json( json ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    cl_aunit_assert=>assert_equals( exp = input_stru
                                    act = ref_stru ).

  ENDMETHOD.                    "test_xstring

  METHOD test_dref.

    DATA input_stru TYPE t_struc1.
    DATA ref_stru   TYPE t_struc1.
    DATA json       TYPE string.

    FIELD-SYMBOLS <inp> TYPE string.
    FIELD-SYMBOLS <ref> TYPE string.

    CREATE DATA input_stru-dr TYPE string.
    ASSIGN input_stru-dr->* TO <inp>.
    <inp> = 'Dref string'.

    json_doc = zcl_json_document=>create_with_data( input_stru ).

    json = json_doc->get_json( ).

    json_doc->set_json( json ).

    json_doc->get_data(
      IMPORTING
        data = ref_stru
    ).

    ASSIGN ref_stru-dr->* TO <ref>.

    cl_aunit_assert=>assert_equals( exp = <inp>
                                    act = <ref> ).

  ENDMETHOD.                    "test_dref

  METHOD test_boolean.

    DATA: BEGIN OF ls_test,
            yyy TYPE boolean,
            xxx TYPE boolean,
          END OF ls_test.

    DATA: ls_test_ref LIKE ls_test.
    DATA: json TYPE string.

    ls_test-xxx = abap_true.

    json_doc = zcl_json_document=>create_with_data( ls_test ).
    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"yyy" :false,"xxx" :true}'
                                    act = json ).

    json_doc->get_data(
      EXPORTING
        json              = json
      IMPORTING
        data              = ls_test_ref
    ).

    cl_aunit_assert=>assert_equals( exp = ls_test
                                    act = ls_test_ref ).

    json_doc = zcl_json_document=>create_with_data(
                     data             = ls_test
                     ignore_boolean   = abap_true
                 ).

    json = json_doc->get_json( ).
    cl_aunit_assert=>assert_equals( exp = '{"yyy" :"","xxx" :"X"}'
                                    act = json ).

  ENDMETHOD.


  METHOD test_transform_simple.

    DATA: BEGIN OF ls_test,
            yyy TYPE string,
            xxx TYPE n LENGTH 3,
          END OF ls_test.

    DATA: ls_test_ref LIKE ls_test.
    DATA: json TYPE string.

    ls_test-yyy = 'Field 1'.
    ls_test-xxx = '123'.

    zcl_json_document=>transform_simple(
      EXPORTING
        data_in              = ls_test
      IMPORTING
        json_out             = json
    ).

    cl_aunit_assert=>assert_equals( exp = '{"RESULT":{"YYY":"Field 1","XXX":"123"}}'
                                    act = json ).

    zcl_json_document=>transform_simple(
      EXPORTING
        json_in              = json
      IMPORTING
        data_out             = ls_test_ref
    ).

    cl_aunit_assert=>assert_equals( exp = ls_test
                                    act = ls_test_ref ).

    zcl_json_document=>transform_simple(
      EXPORTING
        data_in              = ls_test
        lower_case           = abap_true
      IMPORTING
        json_out             = json
    ).

    cl_aunit_assert=>assert_equals( exp = '{"result":{"yyy":"Field 1","xxx":"123"}}'
                                    act = json ).

    CLEAR ls_test_ref.

    zcl_json_document=>transform_simple(
      EXPORTING
        json_in              = json
        lower_case           = abap_true
      IMPORTING
        data_out             = ls_test_ref
    ).

    cl_aunit_assert=>assert_equals( exp = ls_test
                                    act = ls_test_ref ).

  ENDMETHOD.

  METHOD test_name_values.

    DATA json TYPE string.
    DATA name_values TYPE wdy_key_value_list .
    FIELD-SYMBOLS: <name_value> TYPE wdy_key_value .

    json_doc = zcl_json_document=>create_with_json( '{ "foo":"bar", "foo2":"bar2" }' ).
    json_doc->get_name_value_pairs(
      IMPORTING
        name_values = name_values
    ).

    READ TABLE name_values WITH KEY key = 'foo' ASSIGNING <name_value>.
    cl_aunit_assert=>assert_equals( exp = 'bar'
                                    act = <name_value>-value ).

    READ TABLE name_values WITH KEY key = 'foo2' ASSIGNING <name_value>.
    cl_aunit_assert=>assert_equals( exp = 'bar2'
                                    act = <name_value>-value ).

    json_doc->set_name_value_pairs( name_values ).
    json = json_doc->get_json( ).

    cl_aunit_assert=>assert_equals( exp = '{"foo" :"bar","foo2" :"bar2" }'
                                    act = json ).

  ENDMETHOD.

ENDCLASS.                    "lcl_zjson IMPLEMENTATION
