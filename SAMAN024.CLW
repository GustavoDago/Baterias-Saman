                     MEMBER('SAMAN.clw')          ! This is a MEMBER module
UpdateSAMAN PROCEDURE

CurrentTab           STRING(80)
LocalRequest         LONG
OriginalRequest      LONG
LocalResponse        LONG
FilesOpened          LONG
WindowOpened         LONG
WindowInitialized    LONG
ForceRefresh         LONG
ActionMessage        CSTRING(40)
RecordChanged        BYTE,AUTO
Update::Reloop  BYTE
Update::Error   BYTE
History::HIS:Record LIKE(HIS:Record),STATIC
SAV::HIS:Record      LIKE(HIS:Record)
Auto::Attempts       LONG,AUTO
Auto::Save:HIS:NUEVA    LIKE(HIS:NUEVA)
Auto::Save:HIS:NUMERO   LIKE(HIS:NUMERO)
ToolBarMode     UNSIGNED,AUTO
WindowXPos      SIGNED,AUTO,STATIC
WindowYPos      SIGNED,AUTO,STATIC
WindowPosInit   BOOL(False),STATIC
WinResize            WindowResizeType
QuickWindow          WINDOW('Actualizar bater�as'),AT(,,200,180),FONT('MS Sans Serif',8,,),IMM,HLP('UpdateSAMAN'),SYSTEM,GRAY,RESIZE,MDI
                       SHEET,AT(4,4,192,154),USE(?CurrentTab)
                         TAB('General'),USE(?Tab:1)
                           PROMPT('N�mero de bater�a:'),AT(8,20),USE(?HIS:NUMERO:Prompt)
                           ENTRY(@n6),AT(88,20,40,10),MSG('N�mero de bater�a'),ALRT(ShiftF7),USE(HIS:NUMERO),RIGHT(1),REQ
                           PROMPT('C�digo del cliente:'),AT(8,34),USE(?HIS:CLIENTE:Prompt)
                           ENTRY(@n6),AT(88,34,40,10),MSG('C�digo del cliente'),USE(HIS:CLIENTE),RIGHT(1)
                           PROMPT('Tipo de bater�a'),AT(8,48),USE(?HIS:TIPO:Prompt)
                           ENTRY(@s9),AT(88,48,40,10),MSG('Tipo de bater�a'),USE(HIS:TIPO)
                           PROMPT('PLACA:'),AT(8,62),USE(?HIS:PLACA:Prompt)
                           ENTRY(@s4),AT(88,62,40,10),MSG('Tipo de placa'),USE(HIS:PLACA)
                           PROMPT('CAJA:'),AT(8,76),USE(?HIS:CAJA:Prompt)
                           ENTRY(@s3),AT(88,76,40,10),MSG('Material de la caja'),USE(HIS:CAJA)
                           PROMPT('Fecha de alta'),AT(8,90),USE(?HIS:FECHA1:Prompt)
                           ENTRY(@D17),AT(88,90,104,10),MSG('Fecha de alta'),USE(HIS:FECHA1),RIGHT(1)
                           PROMPT('Fecha de baja'),AT(8,104),USE(?HIS:FECHA2:Prompt)
                           ENTRY(@d17),AT(88,104,104,10),MSG('Fecha de baja'),USE(HIS:FECHA2),RIGHT(1)
                           OPTION('Posici�n'),AT(88,118,50,36),MSG('Posici�n (Derecha o Izquierda)'),USE(HIS:POSIC)
                             RADIO('D'),AT(92,128),USE(?HIS:POSIC:Radio1)
                             RADIO('I'),AT(92,140),USE(?HIS:POSIC:Radio2)
                           END
                         END
                         TAB('General (cont.)'),USE(?Tab:2)
                           PROMPT('Cantidad Placas:'),AT(8,20),USE(?HIS:CANTPLACAS:Prompt)
                           ENTRY(@n6),AT(88,20,40,10),MSG('Cantidad de placas'),USE(HIS:CANTPLACAS),RIGHT(1)
                           PROMPT('Garant�a:'),AT(8,34),USE(?HIS:GARANT:Prompt)
                           ENTRY(@n6),AT(88,34,40,10),MSG('Tiempo de garant�a'),USE(HIS:GARANT),RIGHT(1)
                           PROMPT('VEHICULO:'),AT(8,48),USE(?HIS:VEHICULO:Prompt)
                           ENTRY(@s25),AT(88,48,104,10),MSG('Describa el veh�culo'),USE(HIS:VEHICULO)
                           PROMPT('Precio:'),AT(8,62),USE(?HIS:Precio:Prompt),HIDE
                           ENTRY(@n$10.2),AT(88,62,104,10),MSG('Valor de la bater�a'),USE(HIS:Precio),HIDE
                           PROMPT('Tama�o:'),AT(8,76),USE(?HIS:Tama�o:Prompt)
                           LIST,AT(88,76,100,10),MSG('Si es extra small, small o normal'),USE(HIS:Tamanio),DROP(5),FROM('ES|SM|NO')
                         END
                       END
                       BUTTON('OK'),AT(102,162,45,14),USE(?OK),DEFAULT
                       BUTTON('Cancel'),AT(151,162,45,14),USE(?Cancel)
                       BUTTON('Help'),AT(151,4,45,14),USE(?Help),HIDE,STD(STD:Help)
                     END
  CODE
  PUSHBIND
  LocalRequest = GlobalRequest
  OriginalRequest = GlobalRequest
  LocalResponse = RequestCancelled
  ForceRefresh = False
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  IF KEYCODE() = MouseRight
    SETKEYCODE(0)
  END
  DO PrepareProcedure
  CASE LocalRequest
  OF InsertRecord
    ActionMessage = 'Agregar registro'
  OF ChangeRecord
    ActionMessage = 'Modificar registro bater�as'
  OF DeleteRecord
  END
  QuickWindow{Prop:Text} = ActionMessage
  ENABLE(TBarBrwHistory)
  ACCEPT
    CASE EVENT()
    OF EVENT:AlertKey
      IF KEYCODE() = 704 THEN
        DO HistoryField
      END
    OF EVENT:CloseWindow
        DO ClosingWindow
        IF Update::Reloop THEN CYCLE.
    OF EVENT:CloseDown
        DO ClosingWindow
        IF Update::Reloop THEN CYCLE.
      WinResize.Destroy
    OF EVENT:OpenWindow
      DO FORM::AssignButtons
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      END
      SELECT(?HIS:NUMERO:Prompt)
    OF EVENT:GainFocus
      ForceRefresh = True
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      ELSE
        DO RefreshWindow
      END
    OF EVENT:Moved
      GETPOSITION(0,WindowXPos,WindowYPos)
    OF EVENT:Sized
      WinResize.Resize
      ForceRefresh = True
      DO RefreshWindow
    OF Event:Rejected
      BEEP
      DISPLAY(?)
      SELECT(?)
    ELSE
      IF ACCEPTED() = TbarBrwHistory
        DO HistoryField
      END
      IF EVENT() = Event:Completed
        History::HIS:Record = HIS:Record
        CASE LocalRequest
        OF InsertRecord
          PUT(SAMAN)
          CASE ERRORCODE()
          OF NoError
            LocalResponse = RequestCompleted
            POST(Event:CloseWindow)
          OF DupKeyErr
            IF DUPLICATE(HIS:PRINCIPAL)
              IF StandardWarning(Warn:DuplicateKey,'Por nue/rep y N�mero')
                SELECT(?HIS:NUMERO:Prompt)
                VCRRequest = VCRNone
                CYCLE
              END
            END
          ELSE
            IF StandardWarning(Warn:InsertError)
              SELECT(?HIS:NUMERO:Prompt)
              VCRRequest = VCRNone
              CYCLE
            END
          END
        OF ChangeRecord
          LOOP
            LocalResponse = RequestCancelled
            SETCURSOR(Cursor:Wait)
            RecordChanged=false
            IF SAV::HIS:Record <> HIS:Record
              RecordChanged = True
            END
            IF RecordChanged THEN
              Update::Error = RIUpdate:SAMAN(1)
            ELSE
              Update::Error = 0
            END
            SETCURSOR()
            IF Update::Error THEN
              IF Update::Error = 1 THEN
                CASE StandardWarning(Warn:UpdateError)
                OF Button:Yes
                  CYCLE
                OF Button:No
                  POST(Event:CloseWindow)
                  BREAK
                END
              END
              DISPLAY
              SELECT(?HIS:NUMERO:Prompt)
              VCRRequest = VCRNone
            ELSE
              IF RecordChanged THEN
                LocalResponse = RequestCompleted
              END
              POST(Event:CloseWindow)
            END
            BREAK
          END
        END
      END
      IF ToolbarMode = FormMode THEN
        CASE ACCEPTED()
        OF TBarBrwBottom TO TBarBrwUp
        OROF TBarBrwInsert
          VCRRequest=ACCEPTED()
          POST(EVENT:Completed)
        OF TBarBrwHelp
          PRESSKEY(F1Key)
        END
      END
    END
    CASE EVENT()
                OF EVENT:AlertKey                            !Alert processing
                          Unhide(HIS:Precio)
                END
            
    CASE FIELD()
    OF ?CurrentTab
      CASE EVENT()
      OF EVENT:Accepted
        DO RefreshWindow
      OF EVENT:NewSelection
          !Code to assign button control based upon current tab selection
          CASE CHOICE(?CurrentTab)
          OF 1
            DO FORM::AssignButtons
          OF 2
          END
        DO RefreshWindow
      OF EVENT:TabChanging
        DO RefreshWindow
      OF EVENT:Selected
        DO RefreshWindow
      END
    OF ?HIS:NUMERO
      CASE EVENT()
      OF EVENT:AlertKey
        IF KEYCODE() = SHIFTF7 THEN
            UNHIDE(?HIS:Precio)
            UNHIDE(?HIS:Precio:PROMPT)
        END
      END
    OF ?HIS:CLIENTE
      CASE EVENT()
      OF EVENT:Accepted
        CLI:C�digo = HIS:CLIENTE
        GET(CLIENTES,CLI:Porcodi)
        IF ERRORCODE()
          GlobalRequest = SelectRecord
          SelectCLIENTES
          LocalResponse = GlobalResponse
          IF LocalResponse = RequestCompleted
            HIS:CLIENTE = CLI:C�digo
          ELSE
            SELECT(?HIS:CLIENTE)
            CYCLE
          END
        END
        LocalRequest = OriginalRequest
        DO RefreshWindow
        CLI:C�digo = HIS:CLIENTE
        GET(CLIENTES,CLI:Porcodi)
        IF ERRORCODE()
          IF StandardWarning(Warn:NotInFile,'C�digo del cliente','CLIENTES')
            SELECT(?HIS:CLIENTE)
            QuickWindow{Prop:AcceptAll} = False
            CYCLE
          END
        END
      END
    OF ?HIS:TIPO
      CASE EVENT()
      OF EVENT:Accepted
        TIP:Descripci�n = HIS:TIPO
        GET(TIPOS,TIP:principal)
        IF ERRORCODE()
          GlobalRequest = SelectRecord
          SelectTIPOS
          LocalResponse = GlobalResponse
          IF LocalResponse = RequestCompleted
            HIS:TIPO = TIP:Descripci�n
          ELSE
            SELECT(?HIS:TIPO)
            CYCLE
          END
        END
        LocalRequest = OriginalRequest
        DO RefreshWindow
        TIP:Descripci�n = HIS:TIPO
        GET(TIPOS,TIP:principal)
        IF ERRORCODE()
          IF StandardWarning(Warn:NotInFile,'Tipo de bater�a','TIPOS')
            SELECT(?HIS:TIPO)
            QuickWindow{Prop:AcceptAll} = False
            CYCLE
          END
        END
      END
    OF ?HIS:PLACA
      CASE EVENT()
      OF EVENT:Accepted
        PLA:C�digo = HIS:PLACA
        GET(PLACAS,PLA:codiclave)
        IF ERRORCODE()
          GlobalRequest = SelectRecord
          SelectPLACAS
          LocalResponse = GlobalResponse
          IF LocalResponse = RequestCompleted
            HIS:PLACA = PLA:C�digo
          ELSE
            SELECT(?HIS:PLACA)
            CYCLE
          END
        END
        LocalRequest = OriginalRequest
        DO RefreshWindow
        PLA:C�digo = HIS:PLACA
        GET(PLACAS,PLA:codiclave)
        IF ERRORCODE()
          IF StandardWarning(Warn:NotInFile,'Tipo de placa','PLACAS')
            SELECT(?HIS:PLACA)
            QuickWindow{Prop:AcceptAll} = False
            CYCLE
          END
        END
      END
    OF ?HIS:CAJA
      CASE EVENT()
      OF EVENT:Accepted
        CAJ:C�digo = HIS:CAJA
        GET(Cajas,CAJ:KeyC�digo)
        IF ERRORCODE()
          GlobalRequest = SelectRecord
          SelectCajas
          LocalResponse = GlobalResponse
          IF LocalResponse = RequestCompleted
            HIS:CAJA = CAJ:C�digo
          ELSE
            SELECT(?HIS:CAJA)
            CYCLE
          END
        END
        LocalRequest = OriginalRequest
        DO RefreshWindow
        CAJ:C�digo = HIS:CAJA
        GET(Cajas,CAJ:KeyC�digo)
        IF ERRORCODE()
          IF StandardWarning(Warn:NotInFile,'Material de la caja','Cajas')
            SELECT(?HIS:CAJA)
            QuickWindow{Prop:AcceptAll} = False
            CYCLE
          END
        END
      END
    OF ?OK
      CASE EVENT()
      OF EVENT:Accepted
        DO SyncWindow
        IF OriginalRequest = ChangeRecord OR OriginalRequest = InsertRecord
          SELECT()
        ELSE
          POST(EVENT:Completed)
        END
      END
    OF ?Cancel
      CASE EVENT()
      OF EVENT:Accepted
        DO SyncWindow
        LocalResponse = RequestCancelled
        VCRRequest = VCRNone
        POST(Event:CloseWindow)
      END
    OF ?Help
      CASE EVENT()
      OF EVENT:Accepted
        DO SyncWindow
      END
    END
  END
  DO ProcedureReturn
!---------------------------------------------------------------------------
PrepareProcedure ROUTINE
  IF CLIENTES::Used = 0
    CheckOpen(CLIENTES,1)
  END
  CLIENTES::Used += 1
  BIND(CLI:RECORD)
  IF Cajas::Used = 0
    CheckOpen(Cajas,1)
  END
  Cajas::Used += 1
  BIND(CAJ:RECORD)
  IF PLACAS::Used = 0
    CheckOpen(PLACAS,1)
  END
  PLACAS::Used += 1
  BIND(PLA:RECORD)
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  BIND(HIS:RECORD)
  IF TIPOS::Used = 0
    CheckOpen(TIPOS,1)
  END
  TIPOS::Used += 1
  BIND(TIP:RECORD)
  FilesOpened = True
  RISnap:SAMAN
  SAV::HIS:Record = HIS:Record
  IF LocalRequest = InsertRecord
    Elegir()
    LocalResponse = RequestCompleted
    DO PrimeFields
    IF LocalResponse = RequestCancelled
      DO ProcedureReturn
    END
    LocalResponse = RequestCancelled
  END
  IF LocalRequest = DeleteRecord
    IF StandardWarning(Warn:StandardDelete) = Button:OK
      LOOP
        LocalResponse = RequestCancelled
        SETCURSOR(Cursor:Wait)
        IF RIDelete:SAMAN()
          SETCURSOR()
          CASE StandardWarning(Warn:DeleteError)
          OF Button:Yes
            CYCLE
          OF Button:No OROF Button:Cancel
            BREAK
          END
        ELSE
          SETCURSOR()
          LocalResponse = RequestCompleted
        END
        BREAK
      END
    END
    DO ProcedureReturn
  END
  OPEN(QuickWindow)
  WindowOpened=True
  QuickWindow{PROP:MinWidth}=QuickWindow{PROP:Width}
  QuickWindow{PROP:MinHeight}=QuickWindow{PROP:Height}
  WinResize.Initialize(AppStrat:Spread)
  IF WindowPosInit THEN
    SETPOSITION(0,WindowXPos,WindowYPos)
  ELSE
    GETPOSITION(0,WindowXPos,WindowYPos)
    WindowPosInit=True
  END
  ?HIS:NUMERO{PROP:Alrt,255} = 704
  ?HIS:CLIENTE{PROP:Alrt,255} = 704
  ?HIS:TIPO{PROP:Alrt,255} = 704
  ?HIS:PLACA{PROP:Alrt,255} = 704
  ?HIS:CAJA{PROP:Alrt,255} = 704
  ?HIS:FECHA1{PROP:Alrt,255} = 704
  ?HIS:FECHA2{PROP:Alrt,255} = 704
  ?HIS:POSIC{PROP:Alrt,255} = 704
  ?HIS:CANTPLACAS{PROP:Alrt,255} = 704
  ?HIS:GARANT{PROP:Alrt,255} = 704
  ?HIS:VEHICULO{PROP:Alrt,255} = 704
  ?HIS:Precio{PROP:Alrt,255} = 704
  ?HIS:Tamanio{PROP:Alrt,255} = 704
!---------------------------------------------------------------------------
ProcedureReturn ROUTINE
!|
!| This routine provides a common procedure exit point for all template
!| generated procedures.
!|
!| First, all of the files opened by this procedure are closed.
!|
!| Next, if it was opened by this procedure, the window is closed.
!|
!| Next, GlobalResponse is assigned a value to signal the calling procedure
!| what happened in this procedure.
!|
!| Next, we replace the BINDings that were in place when the procedure initialized
!| (and saved with PUSHBIND) using POPBIND.
!|
!| Finally, we return to the calling procedure.
!|
  IF FilesOpened
    CLIENTES::Used -= 1
    IF CLIENTES::Used = 0 THEN CLOSE(CLIENTES).
    Cajas::Used -= 1
    IF Cajas::Used = 0 THEN CLOSE(Cajas).
    PLACAS::Used -= 1
    IF PLACAS::Used = 0 THEN CLOSE(PLACAS).
    SAMAN::Used -= 1
    IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
    TIPOS::Used -= 1
    IF TIPOS::Used = 0 THEN CLOSE(TIPOS).
  END
  IF WindowOpened
    CLOSE(QuickWindow)
  END
  IF LocalResponse
    GlobalResponse = LocalResponse
  ELSE
    GlobalResponse = RequestCancelled
  END
  POPBIND
  RETURN
!---------------------------------------------------------------------------
InitializeWindow ROUTINE
!|
!| This routine is used to prepare any control templates for use. It should be called once
!| per procedure.
!|
  DO RefreshWindow
!---------------------------------------------------------------------------
RefreshWindow ROUTINE
!|
!| This routine is used to keep all displays and control templates current.
!|
  IF QuickWindow{Prop:AcceptAll} THEN EXIT.
  DISPLAY()
  ForceRefresh = False
!---------------------------------------------------------------------------
SyncWindow ROUTINE
!|
!| This routine is used to insure that any records pointed to in control
!| templates are fetched before any procedures are called via buttons or menu
!| options.
!|
!---------------------------------------------------------------------------
ClosingWindow ROUTINE
  Update::Reloop = 0
  IF LocalResponse <> RequestCompleted
    RecordChanged = False
    IF LocalRequest = InsertRecord OR LocalRequest = ChangeRecord
      IF SAV::HIS:Record <> HIS:Record
        RecordChanged = True
      END
    END
    IF RecordChanged
      IF StandardWarning(Warn:ConfirmCancel) = Button:No
        SELECT(?HIS:NUMERO:Prompt)
        Update::Reloop = 1
      END
    END
    IF OriginalRequest = InsertRecord
      IF LocalResponse = RequestCancelled
        DELETE(SAMAN)
      END
    END
  END
!|
!| Copies a field from save buffer to actual buffer switched on current field
!|
HistoryField  ROUTINE
  CASE FOCUS()
    OF ?HIS:NUMERO
      HIS:NUMERO = History::HIS:Record.NUMERO
    OF ?HIS:CLIENTE
      HIS:CLIENTE = History::HIS:Record.CLIENTE
    OF ?HIS:TIPO
      HIS:TIPO = History::HIS:Record.TIPO
    OF ?HIS:PLACA
      HIS:PLACA = History::HIS:Record.PLACA
    OF ?HIS:CAJA
      HIS:CAJA = History::HIS:Record.CAJA
    OF ?HIS:FECHA1
      HIS:FECHA1 = History::HIS:Record.FECHA1
    OF ?HIS:FECHA2
      HIS:FECHA2 = History::HIS:Record.FECHA2
    OF ?HIS:POSIC
      HIS:POSIC = History::HIS:Record.POSIC
    OF ?HIS:CANTPLACAS
      HIS:CANTPLACAS = History::HIS:Record.CANTPLACAS
    OF ?HIS:GARANT
      HIS:GARANT = History::HIS:Record.GARANT
    OF ?HIS:VEHICULO
      HIS:VEHICULO = History::HIS:Record.VEHICULO
    OF ?HIS:Precio
      HIS:Precio = History::HIS:Record.Precio
    OF ?HIS:Tamanio
      HIS:Tamanio = History::HIS:Record.Tamanio
  END
  DISPLAY()
!---------------------------------------------------------------
PrimeFields ROUTINE
!|
!| This routine is called whenever the procedure is called to insert a record.
!|
!| This procedure performs three functions. These functions are..
!|
!|   1. Prime the new record with initial values specified in the dictionary
!|      and under the Field priming on Insert button.
!|   2. Generates any Auto-Increment values needed.
!|   3. Saves a copy of the new record, as primed, for use in batch-adds.
!|
!| If an auto-increment value is generated, this routine will add the new record
!| at this point, keeping its place in the file.
!|
  HIS:Record = SAV::HIS:Record
  HIS:NUEVA = SoN
  HIS:FECHA1 = TODAY()
  SAV::HIS:Record = HIS:Record
  Auto::Attempts = 0
  LOOP
    Auto::Save:HIS:NUEVA = HIS:NUEVA
    CLEAR(HIS:NUMERO,1)
    SET(HIS:PRINCIPAL,HIS:PRINCIPAL)
    PREVIOUS(SAMAN)
    IF ERRORCODE() AND ERRORCODE() <> BadRecErr
      StandardWarning(Warn:RecordFetchError,'SAMAN')
      POST(Event:CloseWindow)
      EXIT
    END
    IF ERRORCODE() |
    OR Auto::Save:HIS:NUEVA <> HIS:NUEVA
      Auto::Save:HIS:NUMERO = 1
    ELSE
      Auto::Save:HIS:NUMERO = HIS:NUMERO + 1
    END
    HIS:Record = SAV::HIS:Record
    HIS:NUMERO = Auto::Save:HIS:NUMERO
    SAV::HIS:Record = HIS:Record
    ADD(SAMAN)
    IF ERRORCODE()
      Auto::Attempts += 1
      IF Auto::Attempts = 3
        IF StandardWarning(Warn:AutoIncError) = Button:Retry
          Auto::Attempts = 0
        ELSE
          LocalResponse = RequestCancelled
          EXIT
        END
      END
      CYCLE
    END
    BREAK
  END
FORM::AssignButtons ROUTINE
  ToolBarMode=FormMode
  DISABLE(TBarBrwFirst,TBarBrwLast)
  ENABLE(TBarBrwHistory)
  CASE OriginalRequest
  OF InsertRecord
    ENABLE(TBarBrwDown)
    ENABLE(TBarBrwInsert)
    TBarBrwDown{PROP:ToolTip}='Save record and add another'
    TBarBrwInsert{PROP:ToolTip}=TBarBrwDown{PROP:ToolTip}
  OF ChangeRecord
    ENABLE(TBarBrwBottom,TBarBrwUp)
    ENABLE(TBarBrwInsert)
    TBarBrwBottom{PROP:ToolTip}='Save changes and go to last record'
    TBarBrwTop{PROP:ToolTip}='Save changes and go to first record'
    TBarBrwPageDown{PROP:ToolTip}='Save changes and page down to record'
    TBarBrwPageUp{PROP:ToolTip}='Save changes and page up to record'
    TBarBrwDown{PROP:ToolTip}='Save changes and go to next record'
    TBarBrwUP{PROP:ToolTip}='Save changes and go to previous record'
    TBarBrwInsert{PROP:ToolTip}='Save this record and add a new one'
  END
  TBarBrwHelp{PROP:Disable}=?Help{PROP:Disable}
  DISPLAY(TBarBrwFirst,TBarBrwLast)

