   PROGRAM

   INCLUDE('Equates.CLW')
   INCLUDE('TplEqu.CLW')
   INCLUDE('Keycodes.CLW')
   INCLUDE('Errors.CLW')
   INCLUDE('ResDef.Clw')
   MAP
     MODULE('SAMAN001.clw')
       Main
     END
     MODULE('SAMAN002.clw')
       BrowseCLIENTES
     END
     MODULE('SAMAN003.clw')
       PrintCLI:Porcodi
     END
     MODULE('SAMAN004.clw')
       PrintCLI:apeynom
     END
     MODULE('SAMAN005.clw')
       BrowseTIPOS
     END
     MODULE('SAMAN006.clw')
       PrintTIP:principal
     END
     MODULE('SAMAN007.clw')
       BrowseCajas
     END
     MODULE('SAMAN008.clw')
       PrintCAJ:KeyCódigo
     END
     MODULE('SAMAN009.clw')
       BrowseSAMAN
     END
     MODULE('SAMAN010.clw')
     END
     MODULE('SAMAN011.clw')
     END
     MODULE('SAMAN012.clw')
     END
     MODULE('SAMAN013.clw')
     END
     MODULE('SAMAN014.clw')
       BrowsePLACAS
     END
     MODULE('SAMAN015.clw')
       PrintPLA:codiclave
     END
     MODULE('SAMAN016.clw')
       PrintPLA:descriclave
     END
     MODULE('SAMAN017.clw')
       UpdateCLIENTES
     END
     MODULE('SAMAN018.clw')
       UpdateTIPOS
     END
     MODULE('SAMAN019.clw')
       UpdateCajas
     END
     MODULE('SAMAN020.clw')
       SelectPLACAS
     END
     MODULE('SAMAN021.clw')
       SelectCajas
     END
     MODULE('SAMAN022.clw')
       SelectTIPOS
     END
     MODULE('SAMAN023.clw')
       SelectCLIENTES
     END
     MODULE('SAMAN024.clw')
       UpdateSAMAN
     END
     MODULE('SAMAN025.clw')
       UpdatePLACAS
     END
     MODULE('SAMAN026.clw')
       Elegir
     END
     MODULE('SAMAN027.clw')
       Inicial
     END
     MODULE('SAMAN_SF.CLW')
       CheckOpen(FILE File,<BYTE OverrideCreate>,<BYTE OverrideOpenMode>)
       ReportPreview(QUEUE PrintPreviewQueue)
       Preview:JumpToPage(LONG Input:CurrentPage, LONG Input:TotalPages),LONG
       Preview:SelectDisplay(*LONG Input:PagesAcross, *LONG Input:PagesDown)
       StandardWarning(LONG WarningID),LONG,PROC
       StandardWarning(LONG WarningID,STRING WarningText1),LONG,PROC
       StandardWarning(LONG WarningID,STRING WarningText1,STRING WarningText2),LONG,PROC
       SetupStringStops(STRING ProcessLowLimit,STRING ProcessHighLimit,LONG InputStringSize,<LONG ListType>)
       NextStringStop,STRING
       SetupRealStops(REAL InputLowLimit,REAL InputHighLimit)
       NextRealStop,REAL
       INIRestoreWindow(STRING ProcedureName,STRING INIFileName)
       INISaveWindow(STRING ProcedureName,STRING INIFileName)
       RISaveError
     END
     MODULE('SAMAN_RU.CLW')
       RIUpdate:CLIENTES(BYTE=0),LONG
       RISnap:CLIENTES
       RIUpdate:Cajas(BYTE=0),LONG
       RISnap:Cajas
       RIUpdate:PLACAS(BYTE=0),LONG
       RISnap:PLACAS
       RIUpdate:SAMAN(BYTE=0),LONG
       RISnap:SAMAN
       RIUpdate:TIPOS(BYTE=0),LONG
       RISnap:TIPOS
       RIUpdate:CLIENTES:SAMAN,LONG
       RIUpdate:Cajas:SAMAN,LONG
       RIUpdate:TIPOS:SAMAN,LONG
     END
     MODULE('SAMAN_RD.CLW')
       RIDelete:CLIENTES,LONG
       RIDelete:Cajas,LONG
       RIDelete:PLACAS,LONG
       RIDelete:SAMAN,LONG
       RIDelete:TIPOS,LONG
       RIDelete:CLIENTES:SAMAN,LONG,PRIVATE
       RIDelete:Cajas:SAMAN,LONG,PRIVATE
       RIDelete:TIPOS:SAMAN,LONG,PRIVATE
     END
   END


SoN   STRING(1)

SaveErrorCode        LONG
SaveError            CSTRING(255)
SaveFileErrorCode    LONG
SaveFileError        CSTRING(255)
GlobalRequest        LONG(0),THREAD
GlobalResponse       LONG(0),THREAD
VCRRequest           LONG(0),THREAD
CLIENTES                FILE,DRIVER('TOPSPEED'),RECLAIM,PRE(CLI),CREATE,BINDABLE,THREAD
Porcodi                  KEY(CLI:Código),NOCASE,OPT,PRIMARY
apeynom                  KEY(CLI:Apellido,CLI:Nombres),DUP,NOCASE,OPT
Record                   RECORD,PRE()
Código                      USHORT
Apellido                    STRING(20)
Nombres                     STRING(20)
Dirección                   STRING(20)
Localidad                   STRING(20)
Teléfono                    STRING(12)
Teléfono1                   STRING(12)
CUIT                        STRING(13)
                         END
                       END
CLIENTES::Used       LONG,THREAD

TIPOS                   FILE,DRIVER('TOPSPEED'),RECLAIM,PRE(TIP),CREATE,BINDABLE,THREAD
principal                KEY(TIP:Descripción),NOCASE,OPT,PRIMARY
Record                   RECORD,PRE()
Descripción                 STRING(9)
                         END
                       END
TIPOS::Used          LONG,THREAD

Cajas                   FILE,DRIVER('TOPSPEED'),PRE(CAJ),CREATE,BINDABLE,THREAD
KeyCódigo                KEY(CAJ:Código),NOCASE,OPT
Record                   RECORD,PRE()
Código                      STRING(3)
Descripción                 STRING(15)
                         END
                       END
Cajas::Used          LONG,THREAD

SAMAN                   FILE,DRIVER('TOPSPEED'),RECLAIM,PRE(HIS),CREATE,BINDABLE,THREAD
PRINCIPAL                KEY(HIS:NUEVA,HIS:NUMERO),OPT,PRIMARY
Placlave                 KEY(HIS:PLACA),DUP,NOCASE,OPT
cajas                    KEY(HIS:CAJA),DUP,NOCASE,OPT
clienclave               KEY(HIS:CLIENTE),DUP,NOCASE,OPT
tipoclave                KEY(HIS:TIPO),DUP,NOCASE,OPT
Record                   RECORD,PRE()
NUEVA                       STRING(1)
NUMERO                      USHORT
CLIENTE                     USHORT
TIPO                        STRING(9)
PLACA                       STRING(4)
CAJA                        STRING(3)
FECHA1                      LONG
FECHA2                      LONG
POSIC                       STRING(1)
CANTPLACAS                  USHORT
GARANT                      USHORT
VEHICULO                    STRING(25)
Precio                      ULONG
Tamanio                     STRING(2)
                         END
                       END
SAMAN::Used          LONG,THREAD

PLACAS                  FILE,DRIVER('TOPSPEED'),RECLAIM,PRE(PLA),CREATE,BINDABLE,THREAD
codiclave                KEY(PLA:Código),NOCASE,OPT,PRIMARY
descriclave              KEY(PLA:Descripción),DUP,NOCASE,OPT
Record                   RECORD,PRE()
Código                      STRING(4)
Descripción                 STRING(15)
                         END
                       END
PLACAS::Used         LONG,THREAD

Sort:Name STRING(ScrollSort:Name)
Sort:Name:Array STRING(3),DIM(100),OVER(Sort:Name)
Sort:Alpha STRING(ScrollSort:Alpha)
Sort:Alpha:Array STRING(2),DIM(100),OVER(Sort:Alpha)
  CODE
  Main
!---------------------------------------------------------------------------

