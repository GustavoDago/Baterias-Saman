                  PROGRAM

                  MAP
                    CheckError(),LONG
                  END

SourceName        STRING(144)
TargetName        STRING(144)
Count             ULONG

CLIENTES            FILE,DRIVER('TOPSPEED'),NAME(SourceName),RECLAIM,PRE(IN:)
Porcodi               KEY(+IN::Código),OPT,NOCASE,PRIMARY
apeynom               KEY(+IN::Apellido,+IN::Nombres),DUP,OPT,NOCASE
RECORD                RECORD
Código                  USHORT
Apellido                STRING(20)
Nombres                 STRING(20)
Dirección               STRING(20)
Localidad               STRING(20)
Teléfono                STRING(12)
Teléfono1               STRING(12)
CUIT                    STRING(13)
                      END
                    END
CLIE                FILE,DRIVER('TOPSPEED'),NAME(TargetName),CREATE,RECLAIM,PRE(CLI1)
Porcodi               KEY(+CLI1:Código),OPT,NOCASE,PRIMARY
apeynom               KEY(+CLI1:Apellido,+CLI1:Nombres),DUP,OPT,NOCASE
RECORD                RECORD
Código                  USHORT
Apellido                STRING(20)
Nombres                 STRING(20)
Dirección               STRING(20)
Localidad               STRING(20)
Teléfono                STRING(12)
Teléfono1               STRING(12)
CUIT                    STRING(13)
                      END
                    END
PROGRESS WINDOW('Converting File'),AT(,,107,33),FONT('MS Sans Serif',8),GRAY,CENTER,DOUBLE
                    STRING('Converting Record #:'),AT(4,13,,)
                    STRING(@n8),AT(74,12,24,12),USE(Count)
                  END

  CODE
  SourceName = 'C:\MISDOC~1\PROGRA~1\BATERÍ~1\CLIENTES.TPS'
  TargetName = 'C:\MISDOC~1\PROGRA~1\BATERÍ~1\CLIENTE1.TPS'

  OPEN(CLIENTES)
  IF CheckError() THEN RETURN.
  SET(CLIENTES)
  CREATE(CLIE)
  IF CheckError() THEN RETURN.
  OPEN(CLIE)
  IF CheckError() THEN RETURN.

  STREAM(CLIENTES)
  STREAM(CLIE)

  OPEN(Progress)

  LOOP
    NEXT(CLIENTES)
    IF ErrorCode() = 33 THEN BREAK.
    DO AssignRecord
    APPEND(CLIE)
    IF CheckError() THEN RETURN.
    Count += 1
    DISPLAY(?Count)
  END

  FLUSH(CLIENTES)
  FLUSH(CLIE)

  BUILD(CLIE)
  CLOSE(CLIENTES)
  CLOSE(CLIE)


AssignRecord      ROUTINE
  CLEAR(CLI1:Record)
  CLI1:CÓDIGO = IN::CÓDIGO
  CLI1:APELLIDO = IN::APELLIDO
  CLI1:NOMBRES = IN::NOMBRES
  CLI1:DIRECCIÓN = IN::DIRECCIÓN
  CLI1:LOCALIDAD = IN::LOCALIDAD
  CLI1:TELÉFONO = IN::TELÉFONO
  CLI1:TELÉFONO1 = IN::TELÉFONO1
  CLI1:CUIT = IN::CUIT

CheckError        FUNCTION
  CODE
  IF ERRORCODE() THEN
    IF MESSAGE('Error: '& ERROR()) THEN
      RETURN ERRORCODE()
    END
  END
  RETURN 0
