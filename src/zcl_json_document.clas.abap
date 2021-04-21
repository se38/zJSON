CLASS zcl_json_document DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPE-POOLS abap .

    TYPES: BEGIN OF ty_name_mapping,
             abap_name TYPE abap_compname,
             json_name TYPE string,
           END OF ty_name_mapping.

    TYPES: tt_name_mappings TYPE STANDARD TABLE OF ty_name_mapping WITH EMPTY KEY.

    METHODS append_data
      IMPORTING
        !data    TYPE any
        !iv_name TYPE string .
    CLASS-METHODS create
      RETURNING
        VALUE(json_document) TYPE REF TO zcl_json_document .
    "! Create a JSON Document with an ABAP data object
    "! @parameter data | ABAP data object
    "! @parameter suppress_itab | Suppress the ITAB prefix if data is a table
    "! @parameter replace_underscore | replace underscore with hyphen
    "! @parameter replace_double_underscore | replace double underscore with CamelCase
    "! @parameter name_mappings | fieldname mappings between ABAP component and JSON fieldname
    CLASS-METHODS create_with_data
      IMPORTING
        data                      TYPE any
        suppress_itab             TYPE boolean OPTIONAL
        ignore_boolean            TYPE boolean OPTIONAL
        dont_escape_ltgt          TYPE boolean OPTIONAL
        numc_as_numeric           TYPE boolean OPTIONAL
        date_format               TYPE char10 OPTIONAL
        replace_underscore        TYPE boolean OPTIONAL
        replace_double_underscore TYPE boolean OPTIONAL
        name_mappings             TYPE tt_name_mappings OPTIONAL
      RETURNING
        VALUE(json_document)      TYPE REF TO zcl_json_document .
    CLASS-METHODS create_with_json
      IMPORTING
        json                 TYPE string
        date_format          TYPE char10 OPTIONAL
        name_mappings        TYPE tt_name_mappings OPTIONAL
      RETURNING
        VALUE(json_document) TYPE REF TO zcl_json_document .
    METHODS dumps
      IMPORTING
        !json           TYPE string OPTIONAL
        !current_intend TYPE i OPTIONAL
      EXPORTING
        !result         TYPE string_table .
    METHODS get_data
      IMPORTING
        !json TYPE string OPTIONAL
      EXPORTING
        !data TYPE any
      RAISING
        zcx_json_document .
    METHODS get_name_value_pairs
      IMPORTING
        !json                    TYPE string OPTIONAL
        !date_format             TYPE char10 OPTIONAL
        !dont_replace_linebreaks TYPE boolean OPTIONAL
      EXPORTING
        !name_values             TYPE wdy_key_value_list
      RAISING
        zcx_json_document .
    METHODS set_name_value_pairs
      IMPORTING
        !name_values TYPE wdy_key_value_list .
    METHODS get_json
      RETURNING
        VALUE(json) TYPE string .
    METHODS get_json_large
      EXPORTING
        !json TYPE string .
    METHODS get_next
      RETURNING
        VALUE(data_found) TYPE boolean .
    METHODS get_value
      IMPORTING
        !key         TYPE string
      RETURNING
        VALUE(value) TYPE string .
    METHODS get_value_int
      IMPORTING
        !key         TYPE string
      RETURNING
        VALUE(value) TYPE i .
    CLASS-METHODS get_version
      RETURNING
        VALUE(version) TYPE string .
    METHODS reset_cursor .
    METHODS set_data
      IMPORTING
        !data                     TYPE any
        !suppress_itab            TYPE boolean OPTIONAL
        !ignore_boolean           TYPE boolean OPTIONAL
        !dont_escape_ltgt         TYPE boolean OPTIONAL
        !numc_as_numeric          TYPE boolean OPTIONAL
        !date_format              TYPE char10 OPTIONAL
        replace_underscore        TYPE boolean OPTIONAL
        replace_double_underscore TYPE boolean OPTIONAL
        name_mappings             TYPE tt_name_mappings OPTIONAL.
    METHODS clear .
    METHODS set_date_format
      IMPORTING
        !date_format TYPE char10 .
    METHODS set_numc_as_numeric
      IMPORTING
        !numc_as_numeric TYPE boolean .
    METHODS set_dont_replace_linebreaks
      IMPORTING
        !dont_replace_linebreaks TYPE boolean .
    METHODS set_dont_escape_ltgt
      IMPORTING
        !dont_escape_ltgt TYPE boolean .
    METHODS set_json
      IMPORTING
        json                    TYPE string
        date_format             TYPE char10 OPTIONAL
        dont_replace_linebreaks TYPE boolean OPTIONAL
        name_mappings           TYPE tt_name_mappings OPTIONAL.
    METHODS set_namespace_conversion
      IMPORTING
        !namespace_1_slash_replace TYPE c
        !namespace_2_slash_replace TYPE c .
    METHODS set_suppress_itab
      IMPORTING
        !suppress_itab TYPE boolean .
    METHODS set_ignore_boolean
      IMPORTING
        !ignore_boolean TYPE boolean .
    METHODS set_replace_underscore
      IMPORTING
        replace_underscore TYPE boolean.
    METHODS set_replace_double_underscore
      IMPORTING
        replace_double_underscore TYPE boolean.
    METHODS set_name_mappings
      IMPORTING
        name_mappings TYPE tt_name_mappings.
    CLASS-METHODS transform_simple
      IMPORTING
        !root_name  TYPE string DEFAULT 'RESULT'
        !json_in    TYPE string OPTIONAL
        !data_in    TYPE any OPTIONAL
        !lower_case TYPE boolean OPTIONAL
      EXPORTING
        !json_out   TYPE string
        !data_out   TYPE any
      RAISING
        zcx_json_document
        cx_xslt_format_error .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS co_version TYPE string VALUE '2.35' ##NO_TEXT.
    DATA json TYPE string .
    DATA data TYPE zjson_key_value_t .
    DATA data_t TYPE string_table .
    DATA array_cursor TYPE i .
    DATA suppress_itab TYPE boolean .
    DATA ignore_boolean TYPE boolean .
    DATA dont_escape_ltgt TYPE boolean .
    DATA numc_as_numeric TYPE boolean .
    DATA dont_replace_linebreaks TYPE boolean .
    DATA replace_underscore TYPE boolean.
    DATA replace_double_underscore TYPE boolean.
    DATA date_format TYPE char10 .
    DATA namespace_replace_pattern TYPE string .
    DATA escape_not_needed TYPE boolean VALUE abap_undefined ##NO_TEXT.
    DATA name_mappings TYPE tt_name_mappings .

    METHODS add_data
      IMPORTING
        !data TYPE any .
    METHODS add_date
      IMPORTING
        !date TYPE d .
    METHODS add_number
      IMPORTING
        !number TYPE any .
    METHODS add_string
      IMPORTING
        !string TYPE any .
    METHODS add_boolean
      IMPORTING
        !string TYPE any .
    METHODS add_stru
      IMPORTING
        !line TYPE any .
    METHODS add_table
      IMPORTING
        !table TYPE ANY TABLE .
    METHODS add_time
      IMPORTING
        !time TYPE t .
    METHODS add_xstring
      IMPORTING
        !xstring TYPE any .
    CLASS-METHODS copyright .
    METHODS escapechar
      IMPORTING
        !json         TYPE string
        !offset       TYPE i
      CHANGING
        !match_result TYPE match_result_tab .
    METHODS format_date
      IMPORTING
        !date                 TYPE d
      RETURNING
        VALUE(date_formatted) TYPE char10 .
    CLASS-METHODS get_kernel_info
      EXPORTING
        !release TYPE i
        !patch   TYPE i .
    METHODS get_offset_close
      IMPORTING
        !json               TYPE string
        !offset_open        TYPE i DEFAULT 0
      RETURNING
        VALUE(offset_close) TYPE i .
    METHODS get_stru
      CHANGING
        !line TYPE any
      RAISING
        zcx_json_document .
    METHODS get_table
      CHANGING
        !table TYPE ANY TABLE
      RAISING
        zcx_json_document .
    METHODS parse
      IMPORTING
        !json TYPE string OPTIONAL .
    METHODS parse_array .
    METHODS parse_object .
    METHODS replace_namespace
      CHANGING
        key TYPE abap_compname .
    METHODS map_abap_to_json_name
      IMPORTING abap_name       TYPE abap_compname
      RETURNING VALUE(r_result) TYPE string.

ENDCLASS.



CLASS zcl_json_document IMPLEMENTATION.


  METHOD add_boolean.

    IF string = abap_true.
      CONCATENATE
        json
        'true'
      INTO json.
    ELSE.
      CONCATENATE
        json
        'false'
      INTO json.
    ENDIF.

  ENDMETHOD.


  METHOD add_data.

    DATA: data_descr TYPE REF TO cl_abap_datadescr.

    data_descr ?= cl_abap_typedescr=>describe_by_data( data ).

    CASE data_descr->type_kind.
      WHEN data_descr->typekind_table.       "table

        add_table( data ).

      WHEN data_descr->typekind_struct1     "flat strcuture
      OR   data_descr->typekind_struct2.     "deep strcuture

        add_stru( data ).

      WHEN data_descr->typekind_char
      OR   data_descr->typekind_string
      OR   data_descr->typekind_clike
      OR   data_descr->typekind_csequence.

        IF data_descr->absolute_name = '\TYPE=BOOLEAN'
        AND me->ignore_boolean IS INITIAL.
          add_boolean( data ).
        ELSE.
          add_string( data ).
        ENDIF.

      WHEN data_descr->typekind_num.          "charlike incl. NUMC.

        IF me->numc_as_numeric IS INITIAL.
          add_string( data ).
        ELSE.
          add_number( data ).
        ENDIF.

      WHEN data_descr->typekind_int
      OR   data_descr->typekind_int1
      OR   data_descr->typekind_int2
      OR   data_descr->typekind_packed.

        add_number( data ).

      WHEN data_descr->typekind_date.

        add_date( data ).

      WHEN data_descr->typekind_time.

        add_time( data ).

      WHEN data_descr->typekind_xstring.

        add_xstring( data ).

      WHEN data_descr->typekind_dref.
        FIELD-SYMBOLS <any> TYPE data.

        IF data IS BOUND.
          ASSIGN data->* TO <any>.
          add_data( <any> ).
        ELSE.
          add_string( `` ).
        ENDIF.

      WHEN data_descr->typekind_hex.      "RAW (ie. GUID)

        DATA: str_data TYPE char512.
        TRY.
            WRITE data TO str_data.
            add_string( str_data ).
          CATCH cx_root.
            add_string( `` ).
        ENDTRY.

*    WHEN data_descr->typekind_float.
*    WHEN data_descr->typekind_w.
*    WHEN data_descr->typekind_oref.
*    WHEN data_descr->typekind_class.
*    WHEN data_descr->typekind_intf.
*    WHEN data_descr->typekind_any.
*    WHEN data_descr->typekind_data.
*    WHEN data_descr->typekind_simple.
*    WHEN data_descr->typekind_xsequence.
*    WHEN data_descr->typekind_numeric.
*    WHEN data_descr->typekind_table.
*    WHEN data_descr->typekind_iref.

*    WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.                    "ADD_DATA


  METHOD add_date.

    DATA: lv_date_c TYPE c LENGTH 10.

    lv_date_c = format_date( date ).

    CONCATENATE
      json
      '"'
      lv_date_c
      '"'
    INTO json.

  ENDMETHOD.                    "ADD_DATE


  METHOD add_number.

    DATA: lv_num_c TYPE c LENGTH 30.

    lv_num_c = number.

    "*--- sign on the left ---*
    IF lv_num_c CS '-'.
      SHIFT lv_num_c RIGHT UP TO '-'.
      SHIFT lv_num_c CIRCULAR RIGHT.
    ENDIF.

    "*--- store NUMC without leading zero (sapcodexch #issue 17) ---*
    SHIFT lv_num_c LEFT DELETING LEADING '0'.

    "*--- if all numbers are deleted, set lv_num_c to zero
    IF lv_num_c IS INITIAL.
      lv_num_c = '0'.
    ENDIF.

    CONDENSE lv_num_c NO-GAPS.

    CONCATENATE
      json
      lv_num_c
    INTO json.

  ENDMETHOD.                    "ADD_NUMBER


  METHOD add_string.

    DATA: lv_string TYPE string.

    "*--- JSON conform conversion ---*
    "*--- sapcodexch issue #4 ---*
    lv_string = string.   "convert to string
    lv_string = cl_http_utility=>if_http_utility~escape_javascript( lv_string ).

    "*--- don't escape single quotes ---*
    "*--- sapcodexch issue #11 ---*
    REPLACE ALL OCCURRENCES OF '\''' IN lv_string WITH ''''.

    "*--- don't escape LT / GT ? ---*
    IF me->dont_escape_ltgt = abap_true.
      REPLACE ALL OCCURRENCES OF '\x3c' IN lv_string WITH '<'.
      REPLACE ALL OCCURRENCES OF '\x3e' IN lv_string WITH '>'.
    ENDIF.

    CONCATENATE
      json
      '"'
      lv_string
      '"'
    INTO json.

  ENDMETHOD.                    "ADD_STRING


  METHOD add_stru.

    DATA: stru_descr       TYPE REF TO cl_abap_structdescr
        , lv_tabix         TYPE sy-tabix
        , comp_name        TYPE abap_compname
        , json_name        TYPE string
        , use_parameter_id TYPE boolean
        .

    FIELD-SYMBOLS: <value> TYPE any
                 , <component> TYPE abap_compdescr
                 .

    DATA lv_parameter_id TYPE string.

    stru_descr ?= cl_abap_typedescr=>describe_by_data( line ).

    CONCATENATE
      json
      '{'
    INTO json.

    LOOP AT stru_descr->components
      ASSIGNING <component>.

      lv_tabix = sy-tabix.

      ASSIGN COMPONENT <component>-name OF STRUCTURE line TO <value>.

      comp_name = <component>-name.

      TRANSLATE comp_name TO LOWER CASE.

      IF me->replace_double_underscore = abap_true.
        DATA l_offset TYPE i.
        FIND FIRST OCCURRENCE OF '__' IN comp_name MATCH OFFSET l_offset.
        WHILE sy-subrc = 0.

          REPLACE '__' IN comp_name WITH ``.

          IF strlen( comp_name ) > l_offset.
            TRANSLATE comp_name+l_offset(1) TO UPPER CASE.
          ENDIF.

          CLEAR l_offset.
          FIND FIRST OCCURRENCE OF '__' IN comp_name MATCH OFFSET l_offset.
        ENDWHILE.
      ENDIF.

      IF me->replace_underscore = abap_true.
        REPLACE '_' IN comp_name WITH '-'.
      ENDIF.

      replace_namespace( CHANGING key = comp_name ).
      json_name = map_abap_to_json_name( comp_name ).

      IF json_name = 'parameter_id'.
*      lv_parameter_id = |{ <value> }|.   ">= 7.02
        lv_parameter_id = <value>.                            "<= 7.01
        use_parameter_id = abap_true.
        CONTINUE.
      ELSEIF json_name = 'data'.
        IF use_parameter_id IS NOT INITIAL.
          json_name = lv_parameter_id.
          CLEAR use_parameter_id.
        ENDIF.
      ENDIF.

      CONCATENATE
        json
        '"'
        json_name
        '" :'
      INTO json.

      add_data( <value> ).

      IF lv_tabix <> lines( stru_descr->components ).
        CONCATENATE
          json
          ','
        INTO json.
      ENDIF.

    ENDLOOP.

    CONCATENATE
      json
      '}'
    INTO json.

  ENDMETHOD.                    "ADD_STRU


  METHOD add_table.

    DATA: lv_tabix TYPE sytabix.
    FIELD-SYMBOLS: <line> TYPE any.

    DATA lv_end TYPE boolean.

    IF strlen( json ) > 3
    OR suppress_itab = abap_true. "sapcodexch issue #13
      CONCATENATE
        json
        ' ['
      INTO json.
    ELSE.
      lv_end = abap_true.
      CONCATENATE
        json
        '{ "itab" : ['
      INTO json.
    ENDIF.

    LOOP AT table
      ASSIGNING <line>.

      lv_tabix = sy-tabix.

      add_data( <line> ).

      IF lv_tabix <> lines( table ).
        CONCATENATE
          json
          ','
        INTO json.
      ENDIF.

    ENDLOOP.

    IF lv_end = abap_true.
      CONCATENATE
        json
        '] }'
      INTO json.
    ELSE.
      CONCATENATE
        json
        ']'
      INTO json.
    ENDIF.
  ENDMETHOD.                    "ADD_TABLE


  METHOD add_time.

    DATA: lv_time_c TYPE c LENGTH 8.

    CONCATENATE
      time(2)
      ':'
      time+2(2)
      ':'
      time+4(2)
    INTO lv_time_c.

    CONCATENATE
      json
      '"'
      lv_time_c
      '"'
    INTO json.

  ENDMETHOD.                    "ADD_TIME


  METHOD add_xstring.

    DATA: lv_string TYPE string.

*  lv_string = cl_http_utility=>encode_x_base64( xstring ) .  ">= 7.02

    "*--- <= 7.01 ---*
    DATA: c_last_error TYPE i.
    DATA: ihttp_scid_base64_escape_x TYPE i VALUE 86.

    SYSTEM-CALL ict
      DID
        ihttp_scid_base64_escape_x
      PARAMETERS
        xstring                            " >
        lv_string                          " <
        c_last_error.                      " < return code

    CONCATENATE
      json
      '"'
      lv_string
      '"'
    INTO json.

  ENDMETHOD.                    "ADD_XSTRING


  METHOD append_data.

    DATA object_found TYPE boolean.

    IF json IS INITIAL.

      CONCATENATE                                             "<= 7.01
        '"'
        iv_name
        '":'
      INTO json.

    ELSE.

      "*--- JSON already an object? ---*
      IF json(1) = '{'.
        object_found = abap_true.
        FIND REGEX '(.{0,})\}$' IN json SUBMATCHES json.  "JSON without the closing bracket
      ENDIF.

      CONCATENATE                                             "<= 7.01
        json
        ', "'
        iv_name
        '":'
      INTO json.

    ENDIF.

    add_data( data ).

    "*--- close the object again ---*
    IF object_found = abap_true.
      CONCATENATE
        json
        '}'
      INTO json.
    ENDIF.

  ENDMETHOD.                    "APPEND_DATA


  METHOD clear.

    CLEAR me->json.
    CLEAR me->data.
    CLEAR me->data_t.

  ENDMETHOD.


  METHOD copyright.

*--------------------------------------------------------------------*
*
* The JSON document class
* Copyright (C) 2010 Uwe Fetzer
*
* Project home: https://github.com/se38/zJSON
*
* Published under Apache License, Version 2.0
* http://www.apache.org/licenses/LICENSE-2.0.html
*
*--------------------------------------------------------------------*

  ENDMETHOD.                    "COPYRIGHT


  METHOD create.

    CREATE OBJECT json_document.

  ENDMETHOD.                    "CREATE


  METHOD create_with_data.

    CREATE OBJECT json_document.
    json_document->set_data(
      data             = data
      suppress_itab    = suppress_itab
      ignore_boolean   = ignore_boolean
      dont_escape_ltgt = dont_escape_ltgt
      numc_as_numeric  = numc_as_numeric
      date_format      = date_format
      replace_underscore = replace_underscore
      replace_double_underscore = replace_double_underscore
      name_mappings    = name_mappings
      ).

  ENDMETHOD.                    "CREATE_WITH_DATA


  METHOD create_with_json.

    CREATE OBJECT json_document.
    json_document->set_json(
      EXPORTING
        json          = json
        date_format   = date_format
        name_mappings = name_mappings
    ).

  ENDMETHOD.                    "CREATE_WITH_JSON


  METHOD dumps.

    DATA: json_doc   TYPE REF TO zcl_json_document
        , json_tmp   TYPE string
        , data_tmp   TYPE zjson_key_value_t
        , data_t_tmp TYPE string_table
        , intend     TYPE i
        , tabix      TYPE sytabix
        , dump       TYPE string_table
        , lines      TYPE i
        .

    FIELD-SYMBOLS: <data_line>   TYPE zjson_key_value
                 , <data_t_line> TYPE string
                 , <result_line> TYPE string
                 .

    IF json IS NOT INITIAL.
      json_tmp = json.
    ELSE.
      json_tmp = me->json.
    ENDIF.

    SHIFT json_tmp LEFT DELETING LEADING space.
    me->json = json_tmp.

    intend = current_intend.

    CASE json_tmp(1).
      WHEN '{'.
        parse_object( ).

        INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
        DO intend TIMES.
*          <result_line> = <result_line> && ` `.
          CONCATENATE
            <result_line>
            ` `
          INTO <result_line> RESPECTING BLANKS.
        ENDDO.
*        <result_line> = <result_line> && `{`.
        CONCATENATE
          <result_line>
          `{`
        INTO <result_line>.
        ADD 4 TO intend.

        CLEAR tabix.

        data_tmp = me->data.

        LOOP AT data_tmp
          ASSIGNING <data_line>.

          ADD 1 TO tabix.          "sy-tabix doesn't work here

          INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
          DO intend TIMES.
*            <result_line> = <result_line> && ` `.
            CONCATENATE
              <result_line>
              ` `
            INTO <result_line> RESPECTING BLANKS.
          ENDDO.

*          <result_line> = |{ <result_line> }"{ <data_line>-key }" : |.
          CONCATENATE
            <result_line>
            `"`
            <data_line>-key
            `" :`
          INTO <result_line>.

          IF <data_line>-value IS INITIAL.

*            <result_line> = |{ <result_line> }""|.
            CONCATENATE
              <result_line>
              `""`
            INTO <result_line>.

          ELSEIF <data_line>-value(1) CN '{['.

            IF <data_line>-value CO '0123456789.'
            AND <data_line>-value(1) <> '0'.        "no leading zero (else asume a string)
*              <result_line> = |{ <result_line> }{ <data_line>-value }|.
              CONCATENATE
                <result_line>
                <data_line>-value
              INTO <result_line>.
            ELSE.
*              <result_line> = |{ <result_line> }"{ <data_line>-value }"|.
              CONCATENATE
                <result_line>
                `"`
                <data_line>-value
                `"`
              INTO <result_line>.
            ENDIF.

          ELSE.
            CLEAR dump.
            json_doc = zcl_json_document=>create_with_json( <data_line>-value ).
            json_doc->dumps( EXPORTING current_intend = intend
                             IMPORTING result = dump ).
            INSERT LINES OF dump INTO TABLE result.
            lines = lines( result ).
            READ TABLE result INDEX lines ASSIGNING <result_line>.

          ENDIF.

          IF tabix < lines( data_tmp ).
*            <result_line> = <result_line> && `,`.
            CONCATENATE
              <result_line>
              `,`
            INTO <result_line>.
          ENDIF.

        ENDLOOP.

        SUBTRACT 4 FROM intend.
        INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
        DO intend TIMES.
*          <result_line> = <result_line> && ` `.
          CONCATENATE
            <result_line>
            ` `
          INTO <result_line> RESPECTING BLANKS.
        ENDDO.
*        <result_line> = <result_line> && `}`.
        CONCATENATE
          <result_line>
          `}`
        INTO <result_line>.

      WHEN '['.
        parse_array( ).

        INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
        DO intend TIMES.
*          <result_line> = <result_line> && ` `.
          CONCATENATE
            <result_line>
            ` `
          INTO <result_line> RESPECTING BLANKS.
        ENDDO.
*        <result_line> = <result_line> && `[`.
        CONCATENATE
          <result_line>
          `[`
        INTO <result_line>.
        ADD 4 TO intend.

        CLEAR tabix.

        data_t_tmp = me->data_t.

        LOOP AT data_t_tmp
          ASSIGNING <data_t_line>.

          ADD 1 TO tabix.          "sy-tabix doesn't work here

          IF <data_t_line>(1) CN '{['.
            INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
            DO intend TIMES.
*              <result_line> = <result_line> && ` `.
              CONCATENATE
                <result_line>
                ` `
              INTO <result_line> RESPECTING BLANKS.
            ENDDO.

*            <result_line> = |{ <result_line> }"{ <data_t_line> }"|.
            CONCATENATE
              <result_line>
              `"`
              <data_t_line>
              `"`
            INTO <result_line>.
          ELSE.
            CLEAR dump.
            json_doc = zcl_json_document=>create_with_json( <data_t_line> ).
            json_doc->dumps( EXPORTING current_intend = intend
                             IMPORTING result = dump ).
            INSERT LINES OF dump INTO TABLE result.
            lines = lines( result ).
            READ TABLE result INDEX lines ASSIGNING <result_line>.
          ENDIF.
          IF tabix < lines( data_t_tmp ).
*            <result_line> = <result_line> && `,`.
            CONCATENATE
              <result_line>
              `,`
            INTO <result_line>.
          ENDIF.

        ENDLOOP.

        SUBTRACT 4 FROM intend.
        INSERT INITIAL LINE INTO TABLE result ASSIGNING <result_line>.
        DO intend TIMES.
*          <result_line> = <result_line> && ` `.
          CONCATENATE
            <result_line>
            ` `
          INTO <result_line> RESPECTING BLANKS.
        ENDDO.
*        <result_line> = <result_line> && `]`.
        CONCATENATE
          <result_line>
          `]`
        INTO <result_line>.

    ENDCASE.

  ENDMETHOD.                    "DUMPS


  METHOD escapechar.

    DATA lv_tab TYPE LINE OF match_result_tab.
    DATA lv_len TYPE i.
    DATA lt_result_tabguillemet TYPE match_result_tab.
    DATA lv_result_tabguillemet TYPE LINE OF match_result_tab.
    DATA lv_pos_echap TYPE i.
    DATA lv_count TYPE i.
    DATA lv_parite TYPE p DECIMALS 1.

    CONSTANTS : c_echap TYPE c VALUE '\'.

    IF escape_not_needed = abap_true.
      RETURN.
    ENDIF.

    IF escape_not_needed = abap_undefined.
      IF json CS c_echap.       "escape needed
        escape_not_needed = abap_false.
      ELSE.
        escape_not_needed = abap_true.
        RETURN.
      ENDIF.
    ENDIF.

    LOOP AT match_result INTO lv_tab.
      FIND ALL OCCURRENCES OF '"' IN json+offset(lv_tab-offset) RESULTS lt_result_tabguillemet.
      CLEAR lv_count.
      LOOP AT lt_result_tabguillemet INTO lv_result_tabguillemet WHERE offset LT lv_tab-offset.
        lv_pos_echap = offset + lv_result_tabguillemet-offset - 1.
        CHECK json+lv_pos_echap(1) NE c_echap.
        lv_count = lv_count + 1.
      ENDLOOP.
      lv_parite = frac( lv_count / 2 ).
      CHECK lv_parite IS NOT INITIAL.
      DELETE match_result.
    ENDLOOP.

  ENDMETHOD.                    "ESCAPECHAR


  METHOD format_date.

    DATA: i   TYPE i,
          fmt TYPE c LENGTH 10.

    IF date_format IS INITIAL.
      date_formatted = date.

    ELSE.

      fmt = date_format.

      IF fmt CS 'YYYY'.
        WRITE date(4) TO date_formatted+sy-fdpos(4).
      ELSEIF fmt CS 'YY'.
        WRITE date+2(2) TO date_formatted+sy-fdpos(2).
      ENDIF.
      IF fmt CS 'MM'.
        WRITE date+4(2) TO date_formatted+sy-fdpos(2).
      ENDIF.
      IF fmt CS 'DD'.
        WRITE date+6(2) TO date_formatted+sy-fdpos(2).
      ENDIF.

* delimiter
      i = 0.
      WHILE NOT fmt IS INITIAL.
        IF fmt(1) NA 'YMD'.
          WRITE fmt(1) TO date_formatted+i(1).
        ENDIF.
        SHIFT fmt LEFT.
        i = i + 1.
      ENDWHILE.

    ENDIF.

  ENDMETHOD.                    "FORMAT_DATE


  METHOD get_data.

    DATA: data_descr TYPE REF TO cl_abap_datadescr.
    DATA: lr_json_doc TYPE REF TO zcl_json_document.
    DATA: lv_json TYPE string.
    DATA: tmp TYPE c LENGTH 10.
    DATA: tmp_s TYPE string.
    DATA: lv_submatch TYPE string.
    DATA: lv_len TYPE i.

    DATA: lr_cx_root TYPE REF TO cx_root.
    DATA: lv_error_text TYPE string.
    DATA: lv_type_kind TYPE string.

    IF json IS NOT INITIAL.
      lv_json = json.
    ELSE.
      lv_json = me->json.
    ENDIF.

    CLEAR data.

    "*--- create new JSON document (recursive!) ---*
    lr_json_doc = zcl_json_document=>create_with_json(
        json          = lv_json
        date_format   = me->date_format
        name_mappings = me->name_mappings
    ).

    data_descr ?= cl_abap_typedescr=>describe_by_data( data ).

    CASE data_descr->type_kind.

      WHEN data_descr->typekind_char         "charlike
      OR   data_descr->typekind_string
      OR   data_descr->typekind_clike
      OR   data_descr->typekind_csequence.

        lr_json_doc->get_json_large(
          IMPORTING
            json = tmp_s
        ).

        lv_len = data_descr->length / cl_abap_char_utilities=>charsize.  "length of field (unicode/non-unicode)

        IF  data_descr->type_kind = data_descr->typekind_char   "character
        AND lv_len = 1.                                          "length 1

          IF tmp_s = 'true'.                                     "-> boolean
            data = abap_true.
          ELSEIF tmp_s = 'false'.
            data = abap_false.
          ELSE.
            data = tmp_s.
          ENDIF.

        ELSE.
          data = tmp_s.
        ENDIF.

        "*--- eliminate surrounding " ---*
        FIND REGEX '^"(.{1,})"' IN data     "get 1-n chars surrounded by quot.marks (sapcodexch issue #22)
          SUBMATCHES lv_submatch.

        IF sy-subrc = 0.
          data = lv_submatch.
        ENDIF.

        "*--- unescape control character ---*
        REPLACE ALL OCCURRENCES OF '\"' IN data WITH '"'.
        REPLACE ALL OCCURRENCES OF '\\' IN data WITH '\'.
        REPLACE ALL OCCURRENCES OF '\/' IN data WITH '/'.
        REPLACE ALL OCCURRENCES OF '\x3c' IN data WITH '<'.
        REPLACE ALL OCCURRENCES OF '\x3e' IN data WITH '>'.

      WHEN data_descr->typekind_num          "NUM + integer + packed (auto conversion)
      OR   data_descr->typekind_int
      OR   data_descr->typekind_int1
      OR   data_descr->typekind_int2
      OR   data_descr->typekind_packed
      OR   data_descr->typekind_hex.        "RAW (ie. GUID)

        lr_json_doc->get_json_large(
          IMPORTING
            json = tmp_s
        ).

        TRY.

            IF data_descr->type_kind <> data_descr->typekind_hex
            AND tmp_s CS 'E'.      "saved as float in JSON string?
              DATA float TYPE f.
              float = tmp_s.
              data = float.
            ELSE.
              data = tmp_s.
            ENDIF.

          CATCH cx_root INTO lr_cx_root.
            lv_error_text = lr_cx_root->get_text( ).
            lv_type_kind = data_descr->type_kind.

            RAISE EXCEPTION TYPE zcx_json_document
              EXPORTING
                textid       = zcx_json_document=>conversation_error
                error_text   = lv_error_text
                type_kind    = lv_type_kind
                actual_value = lv_json.

        ENDTRY.

      WHEN data_descr->typekind_xstring.

        DATA lv_xstring TYPE xstring.

        lr_json_doc->get_json_large(
          IMPORTING
            json = tmp_s
        ).

*        data = cl_http_utility=>decode_x_base64( tmp_s ) .  ">= 7.02

        "*--- <= 7.01 ---*
        DATA: c_last_error TYPE i.
        DATA: ihttp_scid_base64_unescape_x TYPE i VALUE 87.

        SYSTEM-CALL ict
          DID
            ihttp_scid_base64_unescape_x
          PARAMETERS
            tmp_s                            " >
            data                            " <
            c_last_error.                      " < return code

      WHEN data_descr->typekind_time.

        lr_json_doc->get_json_large(
          IMPORTING
            json = tmp_s
        ).

        REPLACE ALL OCCURRENCES OF ':' IN tmp_s WITH ``.
        data = tmp_s.

      WHEN data_descr->typekind_struct1     "flat strcuture
      OR   data_descr->typekind_struct2.     "deep strcuture

        lr_json_doc->get_stru( CHANGING line = data ).

      WHEN data_descr->typekind_table.       "table

        lr_json_doc->get_table( CHANGING table = data ).

      WHEN data_descr->typekind_date.

        lr_json_doc->get_json_large(
          IMPORTING
            json = tmp_s
        ).

        tmp = tmp_s.

        IF date_format IS INITIAL.
          data = tmp.
        ELSE.
          IF date_format CS 'YYYY'.
            DATA(4) = tmp+sy-fdpos(4).
          ELSE.
            FIND 'YY' IN date_format.
            CONCATENATE
              '20'
              tmp+sy-fdpos(2)
            INTO DATA(4).
          ENDIF.

          IF date_format CS 'MM'.
            data+4(2) = tmp+sy-fdpos(2).
          ENDIF.

          IF date_format CS 'DD'.
            data+6(2) = tmp+sy-fdpos(2).
          ENDIF.

        ENDIF.

      WHEN data_descr->typekind_dref.

        "*--- as we don't know the original data type, ---*
        "*--- we always pass back a string dref        ---*
        "*--- (function not really useful)             ---*
        FIELD-SYMBOLS <f> TYPE string.
        CREATE DATA data TYPE string.

        ASSIGN data->* TO <f>.

        lr_json_doc->get_json_large(
          IMPORTING
            json = <f>
        ).

        GET REFERENCE OF <f> INTO data.

*    WHEN data_descr->typekind_float.
*    WHEN data_descr->typekind_w.
*    WHEN data_descr->typekind_oref.
*    WHEN data_descr->typekind_class.
*    WHEN data_descr->typekind_intf.
*    WHEN data_descr->typekind_any.
*    WHEN data_descr->typekind_data.
*    WHEN data_descr->typekind_simple.
*    WHEN data_descr->typekind_xsequence.
*    WHEN data_descr->typekind_numeric.
*    WHEN data_descr->typekind_iref.

*    WHEN OTHERS.

    ENDCASE.

  ENDMETHOD.                    "GET_DATA


  METHOD get_json.

    get_json_large(
      IMPORTING
        json = json
    ).

  ENDMETHOD.                    "GET_JSON


  METHOD get_json_large.

    IF me->json IS NOT INITIAL.

      SHIFT me->json LEFT DELETING LEADING space.

      IF  me->json+0(1) NE `{`
      AND me->json+0(1) NE `[`.    "sapcodexch issue #7

        "*--- key/value pair only (sapcodexch issue #3) ---*
        FIND REGEX '"*":' IN me->json.
        IF sy-subrc = 0.
*        me->json = `{` && `}` && me->json .            ">= 7.02
          CONCATENATE '{' me->json '}' INTO me->json.             "<= 7.01
        ENDIF.
      ENDIF.

    ENDIF.

    json = me->json.

    SHIFT json LEFT DELETING LEADING space.

  ENDMETHOD.                    "GET_JSON_LARGE


  METHOD get_kernel_info.

    TYPES: BEGIN OF ts_kernel_version,
             key(21)  TYPE c,
             data(69) TYPE c,
           END OF ts_kernel_version.

    DATA kernel_version TYPE STANDARD TABLE OF ts_kernel_version.
    FIELD-SYMBOLS <ls_kernel_version> TYPE ts_kernel_version.

    CALL 'SAPCORE' ID 'ID' FIELD 'VERSION'
                   ID 'TABLE' FIELD kernel_version.

    "*--- get kernel release ---*
    READ TABLE kernel_version
      ASSIGNING <ls_kernel_version>
      INDEX 12.

    CHECK sy-subrc = 0.

    release = <ls_kernel_version>-data.

    "*--- get patch level ---*
    READ TABLE kernel_version
      ASSIGNING <ls_kernel_version>
      INDEX 15.

    CHECK sy-subrc = 0.

    patch = <ls_kernel_version>-data.

  ENDMETHOD.                    "get_kernel_info


  METHOD get_name_value_pairs.

    IF date_format IS SUPPLIED.
      set_date_format( date_format ).
    ENDIF.

    IF dont_replace_linebreaks IS SUPPLIED.
      set_dont_replace_linebreaks( dont_replace_linebreaks ).
    ENDIF.

    me->json = json.

    IF me->dont_replace_linebreaks <> abap_true.
      "*--- esp. for CouchDB ---*
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN me->json WITH ``.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN me->json WITH ``.
    ENDIF.

    SHIFT me->json LEFT DELETING LEADING space.

    parse( ).

    name_values = data.

  ENDMETHOD.


  METHOD get_next.

    DATA lv_json TYPE string.
    DATA lt_data LIKE me->data_t.
    DATA lv_cursor LIKE me->array_cursor.

    ADD 1 TO me->array_cursor.

    "*--- get next entry ---*
    READ TABLE me->data_t INDEX me->array_cursor INTO lv_json.

    IF sy-subrc = 0.
      lt_data = me->data_t.    "save data_t (nasted for tables)    codexch issue #20
      lv_cursor = me->array_cursor.

      set_json( lv_json ).

      me->data_t = lt_data.    "restore data_t (nasted for tables) codexch issue #20
      me->array_cursor = lv_cursor.

      data_found = abap_true.
    ENDIF.

  ENDMETHOD.                    "GET_NEXT


  METHOD get_offset_close.

    DATA: lv_offset          TYPE i
        , lv_copen           TYPE c
        , lv_cclose          TYPE c
        , lv_pos_echap       TYPE i
        , lt_result_tabopen  TYPE match_result_tab
        , lt_result_tabclose TYPE match_result_tab
        , lv_offsetclose_old TYPE i
        .

    FIELD-SYMBOLS <lv_result_tabclose> TYPE LINE OF match_result_tab.
    FIELD-SYMBOLS <lv_result_tabopen> TYPE LINE OF match_result_tab.

    CONSTANTS : c_echap TYPE c VALUE '\'.

    lv_copen = json+offset_open(1).
    CASE lv_copen.
      WHEN '"'. lv_cclose = '"'.
      WHEN '{'. lv_cclose = '}'.
      WHEN '['. lv_cclose = ']'.
    ENDCASE.
    lv_offset = offset_open + 1.
    IF lv_copen EQ '"'.
      FIND ALL OCCURRENCES OF lv_cclose IN json+lv_offset RESULTS lt_result_tabclose.

      LOOP AT lt_result_tabclose ASSIGNING <lv_result_tabclose>.
        lv_pos_echap = lv_offset + <lv_result_tabclose>-offset - 1.
        CHECK json+lv_pos_echap(1) NE c_echap.
        EXIT.
      ENDLOOP.
      offset_close = lv_offset + <lv_result_tabclose>-offset + 1. "CBO due to change in the else statement
    ELSE.

      FIND ALL OCCURRENCES OF lv_copen IN json+lv_offset RESULTS lt_result_tabopen.

      escapechar(
        EXPORTING
          json = json
          offset = lv_offset
        CHANGING
          match_result = lt_result_tabopen
        ).

      FIND ALL OCCURRENCES OF lv_cclose IN json+lv_offset RESULTS lt_result_tabclose.

      escapechar(
        EXPORTING
          json = json
          offset = lv_offset
        CHANGING
          match_result = lt_result_tabclose
        ).

*   CHANGING CBO : We look to the first close where no open is set before
*                by removing each open corresponding of each close
      DATA lv_last_idx LIKE sy-tabix.
      LOOP AT lt_result_tabclose ASSIGNING <lv_result_tabclose>.
        lv_last_idx = -1.
        LOOP AT lt_result_tabopen ASSIGNING <lv_result_tabopen>
          WHERE offset BETWEEN 0 AND <lv_result_tabclose>-offset.
          lv_last_idx = sy-tabix.
        ENDLOOP.
        IF NOT lv_last_idx = -1 .
          DELETE lt_result_tabopen INDEX lv_last_idx.
        ELSE.
          offset_close = lv_offset + <lv_result_tabclose>-offset + 1.
          EXIT.
        ENDIF.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.                    "GET_OFFSET_CLOSE


  METHOD get_stru.

    DATA: stru_descr   TYPE REF TO cl_abap_structdescr
        , comp_name    TYPE abap_compname
        , json_name    TYPE string
        , lv_json      TYPE string
        .

    FIELD-SYMBOLS: <value> TYPE any
                 , <component> TYPE abap_compdescr
                 .

    stru_descr ?= cl_abap_typedescr=>describe_by_data( line ).

    LOOP AT stru_descr->components
      ASSIGNING <component>.

      ASSIGN COMPONENT <component>-name OF STRUCTURE line TO <value>.

      comp_name = <component>-name.
      TRANSLATE comp_name TO LOWER CASE.

      json_name = map_abap_to_json_name( comp_name ).
      TRANSLATE json_name TO LOWER CASE.
      lv_json = me->get_value( json_name ).

      CHECK lv_json IS NOT INITIAL.    "value found?  "sapcodexch issue #6

      "*--- and again -> recursive! ---*
      me->get_data(
        EXPORTING json = lv_json
        IMPORTING data = <value>
        ).

    ENDLOOP.

  ENDMETHOD.                    "GET_STRU


  METHOD get_table.

    DATA: table_descr  TYPE REF TO cl_abap_tabledescr
        , data_descr   TYPE REF TO cl_abap_datadescr
        , stru_descr   TYPE REF TO cl_abap_structdescr
        , comp_name    TYPE string
        , lv_json      TYPE string
        .

    FIELD-SYMBOLS: <value> TYPE any
                 , <line>  TYPE any
                 , <component> TYPE abap_compdescr
                 .

    table_descr ?= cl_abap_typedescr=>describe_by_data( table ).

    "*--- currently only standard tables possible (no hashed/sorted) ---*
    CHECK table_descr->table_kind = table_descr->tablekind_std.

    data_descr ?= table_descr->get_table_line_type( ).

    "*--- check structure or simple ---*
    IF data_descr->type_kind = data_descr->typekind_struct1     "flat strcuture
    OR data_descr->type_kind = data_descr->typekind_struct2.    "deep strcuture
      stru_descr ?= data_descr.
    ENDIF.

    WHILE me->get_next( ) IS NOT INITIAL.

      INSERT INITIAL LINE INTO TABLE table ASSIGNING <line>.

      IF stru_descr IS NOT BOUND.    "table line is not a structure

        me->get_data(
          EXPORTING json = lv_json
          IMPORTING data = <line>
          ).

      ELSE.

        LOOP AT stru_descr->components
          ASSIGNING <component>.

          ASSIGN COMPONENT <component>-name OF STRUCTURE <line> TO <value>.

          comp_name = <component>-name.
          TRANSLATE comp_name TO LOWER CASE.
          lv_json = me->get_value( comp_name ).

          CHECK lv_json IS NOT INITIAL.    "value found?  "sapcodexch issue #6

          "*--- and again -> recursive! ---*
          me->get_data(
            EXPORTING json = lv_json
            IMPORTING data = <value>
            ).

        ENDLOOP.

      ENDIF.

    ENDWHILE.

  ENDMETHOD.                    "GET_TABLE


  METHOD get_value.

    FIELD-SYMBOLS: <data> TYPE zjson_key_value.

    READ TABLE me->data
      ASSIGNING <data>
      WITH TABLE KEY
        key = key.

    IF sy-subrc = 0.
      value = <data>-value.
    ENDIF.

  ENDMETHOD.                    "GET_VALUE


  METHOD get_value_int.

    DATA: lv_value_string TYPE string.
    FIELD-SYMBOLS: <data> TYPE zjson_key_value.

    READ TABLE me->data
      ASSIGNING <data>
      WITH TABLE KEY
      key = key.

    IF sy-subrc = 0.
      lv_value_string = <data>-value.
    ENDIF.

    IF lv_value_string CO ' 1234567890-'.
      value = lv_value_string.
    ENDIF.

  ENDMETHOD.                    "GET_VALUE_INT


  METHOD get_version.

    version = co_version.

  ENDMETHOD.                    "GET_VERSION


  METHOD parse.

    escape_not_needed = abap_undefined.

    "*--- new data given ---*
    IF json IS NOT INITIAL.

      set_json( json ).

    ELSE.

      CHECK me->json IS NOT INITIAL.  "Codexch issue #1 CX_SY_RANGE_OUT_OF_BOUNDS

      CASE me->json(1).
        WHEN '['.
          parse_array( ).
        WHEN '{'.
          parse_object( ).
        WHEN OTHERS.
          RETURN.
      ENDCASE.

    ENDIF.

  ENDMETHOD.                    "PARSE


  METHOD parse_array.

    DATA: lv_json      TYPE string
        , lv_json_part TYPE string
        , lv_close     TYPE i
        , data         TYPE zjson_key_value_t
        .

    lv_json = me->json.

    CLEAR me->data_t.
    CLEAR me->array_cursor.

    REPLACE REGEX '^\[' IN lv_json WITH ``.   "codexch issue #20
    REPLACE REGEX '\]$' IN lv_json WITH ``.   "codexch issue #20

    SHIFT lv_json LEFT DELETING LEADING space. "codexch issue #35

    WHILE NOT lv_json CO space.

      CASE lv_json(1).

        WHEN '{' OR '['.          "object or array

          lv_close = get_offset_close( lv_json ).

          "*--- get object ---*
          lv_json_part = lv_json(lv_close).
          INSERT lv_json_part INTO TABLE me->data_t.

          lv_json = lv_json+lv_close.

        WHEN '"'.          "string

          lv_close = get_offset_close( lv_json ) - 2.  "w/o "

          "*--- get object ---*
          IF lv_close > 0.
            lv_json_part = lv_json+1(lv_close).
          ELSE.
            CLEAR lv_json_part.
          ENDIF.

          INSERT lv_json_part INTO TABLE me->data_t.

          ADD 2 TO lv_close.
          lv_json = lv_json+lv_close.

        WHEN OTHERS.       "numbers, boolean, NULL

          SPLIT lv_json AT ',' INTO lv_json_part lv_json.
          SHIFT lv_json_part LEFT DELETING LEADING space.
          INSERT lv_json_part INTO TABLE me->data_t.

      ENDCASE.

      SHIFT lv_json LEFT DELETING LEADING space.
      SHIFT lv_json LEFT DELETING LEADING ','.
      SHIFT lv_json LEFT DELETING LEADING space.

    ENDWHILE.

  ENDMETHOD.                    "PARSE_ARRAY


  METHOD parse_object.

    DATA: lv_json TYPE string
        , lv_close TYPE i
        , ls_key_value TYPE zjson_key_value
        .

    lv_json = me->json.
    CLEAR me->data.

    WHILE NOT lv_json CO '{} '.

      "*--- get key ---*
      SHIFT lv_json LEFT UP TO '"'.
      lv_close = get_offset_close( lv_json ).

      SUBTRACT 2 FROM lv_close.
      ls_key_value-key = lv_json+1(lv_close).
      TRANSLATE ls_key_value-key TO LOWER CASE.   "sapcodexch ticket #5

      "*--- get value ---*
      SHIFT lv_json LEFT UP TO ':'.
      SHIFT lv_json LEFT.
      SHIFT lv_json LEFT DELETING LEADING space.

      CASE lv_json(1).
        WHEN '"'.
          lv_close = get_offset_close( lv_json ).
          SUBTRACT 2 FROM lv_close.
          ls_key_value-value = lv_json+1(lv_close).
          ADD 2 TO lv_close.
          lv_json = lv_json+lv_close.
        WHEN '{' OR '['.
          lv_close = get_offset_close( lv_json ).
          ls_key_value-value = lv_json+0(lv_close).
          ADD 1 TO lv_close.
          lv_json = lv_json+lv_close.
        WHEN OTHERS.     "boolean, numbers
          SPLIT lv_json AT ',' INTO ls_key_value-value lv_json.
          REPLACE '}' WITH `` INTO ls_key_value-value.   "last one of the list
      ENDCASE.

      INSERT ls_key_value INTO TABLE me->data.
    ENDWHILE.

  ENDMETHOD.                    "PARSE_OBJECT


  METHOD replace_namespace.

    DATA namespace TYPE string.

    CHECK namespace_replace_pattern IS NOT INITIAL.

*    REPLACE REGEX `/(\w+)/` IN cv_key WITH mv_namespace_replace_pattern.  ">= 7.31

    "*--- < 7.31 ---*
    FIND REGEX `/(\w+)/` IN key SUBMATCHES namespace.

    IF namespace IS NOT INITIAL.
      REPLACE REGEX `/(\w+)/` IN key WITH namespace_replace_pattern.
      REPLACE '&1' IN key WITH namespace.
      CONDENSE key.
    ENDIF.

  ENDMETHOD.                    "REPLACE_NAMESPACE


  METHOD reset_cursor.

    CLEAR me->array_cursor.

  ENDMETHOD.                    "RESET_CURSOR


  METHOD set_data.

    IF suppress_itab IS SUPPLIED.
      set_suppress_itab( suppress_itab ).
    ENDIF.

    IF ignore_boolean IS SUPPLIED.
      set_ignore_boolean( ignore_boolean ).
    ENDIF.

    IF dont_escape_ltgt IS SUPPLIED.
      set_dont_escape_ltgt( dont_escape_ltgt ).
    ENDIF.

    IF date_format IS SUPPLIED.
      set_date_format( date_format ).
    ENDIF.

    IF numc_as_numeric IS SUPPLIED.
      set_numc_as_numeric( numc_as_numeric ).
    ENDIF.

    IF replace_underscore IS SUPPLIED.
      set_replace_underscore( replace_underscore ).
    ENDIF.

    IF replace_double_underscore IS SUPPLIED.
      set_replace_double_underscore( replace_double_underscore ).
    ENDIF.

    IF name_mappings IS SUPPLIED.
      set_name_mappings( name_mappings ).
    ENDIF.

    CLEAR json.
    add_data( data ).

    parse( ).

  ENDMETHOD.                    "SET_DATA


  METHOD set_date_format.

    me->date_format = date_format.

  ENDMETHOD.                    "SET_DATE_FORMAT


  METHOD set_dont_escape_ltgt.

    me->dont_escape_ltgt = dont_escape_ltgt.

  ENDMETHOD.                    "set_dont_escape_ltgt


  METHOD set_dont_replace_linebreaks.
    me->dont_replace_linebreaks = dont_replace_linebreaks.
  ENDMETHOD.


  METHOD set_ignore_boolean.

    me->ignore_boolean = ignore_boolean.

  ENDMETHOD.                    "SET_SUPPRESS_ITAB


  METHOD set_json.

    IF date_format IS SUPPLIED.
      set_date_format( date_format ).
    ENDIF.

    IF dont_replace_linebreaks IS SUPPLIED.
      set_dont_replace_linebreaks( dont_replace_linebreaks ).
    ENDIF.

    IF name_mappings IS SUPPLIED.
      set_name_mappings( name_mappings ).
    ENDIF.

    me->json = json.

    IF me->dont_replace_linebreaks <> abap_true.
      "*--- esp. for CouchDB ---*
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf IN me->json WITH ``.
      REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline IN me->json WITH ``.
    ENDIF.

    SHIFT me->json LEFT DELETING LEADING space.

    parse( ).

  ENDMETHOD.                    "SET_JSON


  METHOD set_namespace_conversion.

    IF  namespace_1_slash_replace IS INITIAL
    AND namespace_2_slash_replace IS INITIAL.
      CLEAR namespace_replace_pattern.
    ELSE.
      CONCATENATE
        namespace_1_slash_replace
        '&1'
        namespace_2_slash_replace
      INTO namespace_replace_pattern.
    ENDIF.

  ENDMETHOD.                    "SET_NAMESPACE_CONVERSION


  METHOD set_name_value_pairs.

    FIELD-SYMBOLS <name_value> TYPE wdr_simple_name_value.

    json = '{'.
    LOOP AT name_values ASSIGNING <name_value>.

      "*--- is value itself a JSON string? -> no quotation marks ---*
      DATA value TYPE string.
      DATA off TYPE i.
      DATA is_json TYPE boolean.
      value = <name_value>-value.
      IF value IS NOT INITIAL.
        SHIFT value LEFT DELETING LEADING space.
        IF value(1) CA '{['.
          off = strlen( value ) - 1.   "offset of last character
          IF value+off(1) CA ']}'.
            is_json = abap_true.    "value is (probably) JSON
          ENDIF.
        ENDIF.
      ENDIF.

      IF is_json IS INITIAL.
        CONCATENATE
          json
          '"'
          <name_value>-name
          '" :"'
          <name_value>-value
          '"'
        INTO json.
      ELSE.
        CONCATENATE
          json
          '"'
          <name_value>-name
          '" :'
          <name_value>-value
        INTO json.
        CLEAR is_json.
      ENDIF.

      IF sy-tabix <> lines( name_values ).
        CONCATENATE
          json
          ','
        INTO json.
      ENDIF.

    ENDLOOP.

    CONCATENATE
      json
      ' }'
    INTO json.

    data = name_values.

  ENDMETHOD.


  METHOD set_numc_as_numeric.
    me->numc_as_numeric = numc_as_numeric.
  ENDMETHOD.


  METHOD set_suppress_itab.

    me->suppress_itab = suppress_itab.

  ENDMETHOD.                    "SET_SUPPRESS_ITAB


  METHOD transform_simple.

    "see http://scn.sap.com/people/horst.keller/blog/2013/01/07/abap-and-json
    "see also SAP note 1648418

    "*--- first check kernel version ---*
    DATA release TYPE i.
    DATA patch TYPE i.

    get_kernel_info(
      IMPORTING
        release = release
        patch   = patch
        ).

    IF release < 720
    OR release = 720 AND patch < 116.
      RAISE EXCEPTION TYPE zcx_json_document
        EXPORTING
          textid = zcx_json_document=>not_supported.
    ENDIF.

    "*--- check whether current basis release supports JSON transformation ---*
    FIELD-SYMBOLS <type> TYPE if_sxml=>xml_stream_type.

    ASSIGN ('if_sxml=>co_xt_json') TO <type>.

    IF <type> IS NOT ASSIGNED.
      RAISE EXCEPTION TYPE zcx_json_document
        EXPORTING
          textid = zcx_json_document=>not_supported.
    ENDIF.

    "*--- transform ---*
    DATA writer TYPE REF TO if_sxml_writer.
    DATA writer_out TYPE REF TO cl_sxml_string_writer.
    DATA reader TYPE REF TO if_sxml_reader.
    DATA jsonx TYPE xstring.
    DATA conv_in TYPE REF TO cl_abap_conv_in_ce.
    DATA param_t TYPE abap_trans_srcbind_tab.
    DATA node TYPE REF TO if_sxml_node.
    DATA node_el TYPE REF TO if_sxml_open_element.
    DATA att TYPE if_sxml_attribute=>attributes.
    DATA varname TYPE string.

    FIELD-SYMBOLS <param> LIKE LINE OF param_t.
    FIELD-SYMBOLS <att> TYPE REF TO if_sxml_attribute.

    IF json_in IS NOT INITIAL.

      INSERT INITIAL LINE INTO TABLE param_t ASSIGNING <param>.
      <param>-name = root_name.
      GET REFERENCE OF data_out INTO <param>-value.

      "*--- field names contain lower case character? ---*
      IF lower_case = abap_true.

        "*--- convert field names to upper case ---*
        CALL METHOD ('CL_ABAP_CODEPAGE')=>convert_to  "dyn call because of downward compatibility
          EXPORTING
            source = json_in    " Source String
          RECEIVING
            result = jsonx.

        reader = cl_sxml_string_reader=>create( jsonx ).
        writer ?= cl_sxml_string_writer=>create( type = <type> ).   "type = if_sxml=>co_xt_json

        node = reader->read_next_node( ).

        WHILE node IS NOT INITIAL.

          IF node->type = if_sxml_node=>co_nt_element_open.
            node_el ?= node.
            att = node_el->get_attributes( ).

            LOOP AT att ASSIGNING <att>.
              CHECK <att>->qname-name = 'name'.
              varname = <att>->get_value( ).
              TRANSLATE varname TO UPPER CASE.
              <att>->set_value( varname ).
            ENDLOOP.

          ENDIF.

          writer->write_node( node ).

          node = reader->read_next_node( ).
        ENDWHILE.

        writer_out ?= writer.
        jsonx = writer_out->get_output( ).

        "*--- JSONX (upper case) -> ABAP ---*
        CALL TRANSFORMATION id SOURCE XML jsonx
                               RESULT (param_t).

      ELSE.

        "*--- JSON -> ABAP ---*
        CALL TRANSFORMATION id SOURCE XML json_in
                               RESULT (param_t).

      ENDIF.

    ELSE.
      "*--- ABAP -> JSON ---*
      INSERT INITIAL LINE INTO TABLE param_t ASSIGNING <param>.
      <param>-name = root_name.
      GET REFERENCE OF data_in INTO <param>-value.

      writer_out = cl_sxml_string_writer=>create( type = <type> ).  "type = if_sxml=>co_xt_json
      CALL TRANSFORMATION id SOURCE (param_t)
                             RESULT XML writer_out.
      jsonx = writer_out->get_output( ).

      "*--- field names as lower case characters? ---*
      IF lower_case = abap_true.

        reader = cl_sxml_string_reader=>create( jsonx ).
        writer ?= cl_sxml_string_writer=>create( type = <type> ).   "type = if_sxml=>co_xt_json

        node = reader->read_next_node( ).

        WHILE node IS NOT INITIAL.

          IF node->type = if_sxml_node=>co_nt_element_open.
            node_el ?= node.
            att = node_el->get_attributes( ).

            LOOP AT att ASSIGNING <att>.
              CHECK <att>->qname-name = 'name'.
              varname = <att>->get_value( ).
              TRANSLATE varname TO LOWER CASE.
              <att>->set_value( varname ).
            ENDLOOP.

          ENDIF.

          writer->write_node( node ).

          node = reader->read_next_node( ).
        ENDWHILE.

        writer_out ?= writer.
        jsonx = writer_out->get_output( ).

      ENDIF.

      "*--- convert xstring to string ---*
      TRY.
          conv_in = cl_abap_conv_in_ce=>create( input = jsonx ).
          conv_in->read( IMPORTING data = json_out ).

        CATCH cx_root.
*          ##no_handler     "inactive for 7.01
      ENDTRY.

    ENDIF.

  ENDMETHOD.                    "TRANSFORM_SIMPLE

  METHOD set_replace_underscore.
    me->replace_underscore = replace_underscore.
  ENDMETHOD.

  METHOD set_replace_double_underscore.
    me->replace_double_underscore = replace_double_underscore.
  ENDMETHOD.

  METHOD set_name_mappings.

    FIELD-SYMBOLS: <name_mapping> TYPE ty_name_mapping.
    DATA name_mapping TYPE ty_name_mapping.

    LOOP AT name_mappings INTO name_mapping.
      INSERT name_mapping INTO TABLE me->name_mappings ASSIGNING <name_mapping>.
      TRANSLATE <name_mapping>-abap_name TO LOWER CASE.
    ENDLOOP.

  ENDMETHOD.


  METHOD map_abap_to_json_name.

    DATA name_mapping TYPE ty_name_mapping.

    READ TABLE me->name_mappings
      WITH KEY abap_name = abap_name
      INTO name_mapping.

    IF sy-subrc = 0.
      r_result = name_mapping-json_name.
    ELSE.
      r_result = abap_name.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
