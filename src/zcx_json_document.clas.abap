class ZCX_JSON_DOCUMENT definition
  public
  inheriting from CX_STATIC_CHECK
  final
  create public .

public section.

  interfaces IF_T100_MESSAGE .

  constants:
    BEGIN OF conversation_error,
        msgid TYPE symsgid VALUE 'ZJSON',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'ERROR_TEXT',
        attr2 TYPE scx_attrname VALUE 'TYPE_KIND',
        attr3 TYPE scx_attrname VALUE 'ACTUAL_VALUE',
        attr4 TYPE scx_attrname VALUE '',
      END OF conversation_error .
  constants:
    BEGIN OF not_supported,
        msgid TYPE symsgid VALUE 'ZJSON',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF not_supported .
  constants:
    BEGIN OF java_script_error,
        msgid TYPE symsgid VALUE 'ZJSON',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'ERROR_TEXT',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF java_script_error .
  data ERROR_TEXT type STRING .
  data TYPE_KIND type STRING .
  data ACTUAL_VALUE type STRING .

  methods CONSTRUCTOR
    importing
      !TEXTID like IF_T100_MESSAGE=>T100KEY optional
      !PREVIOUS like PREVIOUS optional
      !ERROR_TEXT type STRING optional
      !TYPE_KIND type STRING optional
      !ACTUAL_VALUE type STRING optional .
protected section.
private section.
ENDCLASS.



CLASS ZCX_JSON_DOCUMENT IMPLEMENTATION.


  method CONSTRUCTOR.
CALL METHOD SUPER->CONSTRUCTOR
EXPORTING
PREVIOUS = PREVIOUS
.
me->ERROR_TEXT = ERROR_TEXT .
me->TYPE_KIND = TYPE_KIND .
me->ACTUAL_VALUE = ACTUAL_VALUE .
clear me->textid.
if textid is initial.
  IF_T100_MESSAGE~T100KEY = IF_T100_MESSAGE=>DEFAULT_TEXTID.
else.
  IF_T100_MESSAGE~T100KEY = TEXTID.
endif.
  endmethod.
ENDCLASS.
