                  PROGRAM

                  MAP
                    CheckError(),LONG
                  END

SourceName        STRING(144)
TargetName        STRING(144)
Count             ULONG

CLIENTES            FILE,DRIVER('TOPSPEED'),NAME(SourceName),RECLAIM,PRE(IN:)
Porcodi               KEY(+IN::C�digo),OPT,NOCASE,PRIMARY
apeynom               KEY(+IN::Apellido,+IN::Nombres),DUP,OPT,NOCASE
RECORD                RECORD
C�digo                  USHORT
Apellido                STRING(20)
Nombres                 STRING(20)
Direcci�n               STRING(20)
Localidad               STRING(20)
Tel�fono                STRING(12)
Tel�fono1               STRING(12)
CUIT                    STRING(13)
                      END
                    END
CLIE                FILE,DRIVER('TOPSPEED'),NAME(TargetName),CREATE,RECLAIM,PRE(CLI1)
Porcodi               KEY(+CLI1:C�digo),OPT,NOCASE,PRIMARY
apeynom               KEY(+CLI1:Apellido,+CLI1:Nombres),DUP,OPT,NOCASE
RECORD                RECORD
C�digo                  USHORT
Apellido                STRING(20)
Nombres                 STRING(20)
Direcci�n               STRING(20)
Localidad               STRING(20)
Tel�fono                STRING(12)
Tel�fono1               STRING(12)
CUIT                    STRING(13)
                      END
                    END
PROGRESS WINDOW('Converting File'),AT(,,107,33),FONT('MS Sans Serif',8),GRAY,CENTER,DOUBLE
                    STRING('Converting Record #:'),AT(4,13,,)
                    STRING(@n8),AT(74,12,24,12),USE(Count)
                  END

  CODE
  SourceName = 'C:\MISDOC~1\PROGRA~1\BATER�~1\CLIENTES.TPS'
  TargetName = 'C:\MISDOC~1\PROGRA~1\BATER�~1\CLIENTE1.TPS'

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
  CLI1:C�DIGO = IN::C�DIGO
  CLI1:APELLIDO = IN::APELLIDO
  CLI1:NOMBRES = IN::NOMBRES
  CLI1:DIRECCI�N = IN::DIRECCI�N
  CLI1:LOCALIDAD = IN::LOCALIDAD
  CLI1:TEL�FONO = IN::TEL�FONO
  CLI1:TEL�FONO1 = IN::TEL�FONO1
  CLI1:CUIT = IN::CUIT

CheckError        FUNCTION
  CODE
  IF ERRORCODE() THEN
    IF MESSAGE('Error: '& ERROR()) THEN
      RETURN ERRORCODE()
    END
  END
  RETURN 0
