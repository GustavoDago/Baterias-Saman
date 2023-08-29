                     MEMBER('SAMAN.clw')          ! This is a MEMBER module
Main PROCEDURE

LocalRequest         LONG
OriginalRequest      LONG
LocalResponse        LONG
FilesOpened          LONG
WindowOpened         LONG
WindowInitialized    LONG
ForceRefresh         LONG
CurrentTab           STRING(80)
SplashProcedureThread LONG
DisplayDayString STRING('Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday ')
DisplayDayText   STRING(9),DIM(7),OVER(DisplayDayString)
AppFrame             APPLICATION('SISTEMA BATERÍAS SAMAN'),AT(,,409,225),FONT('MS Sans Serif',8,,),CENTER,ICON('BATERIA.ICO'),STATUS(-1,80,120,45),SYSTEM,MAX,RESIZE,IMM
                       MENUBAR
                         MENU('&Archivo'),USE(?Archivo)
                           ITEM('&Configurar impresora...'),USE(?PrintSetup),MSG('Setup printer'),STD(STD:PrintSetup)
                           ITEM,SEPARATOR
                           ITEM('Salida'),USE(?Exit),MSG('Salir de la aplicación'),STD(STD:Close)
                         END
                         MENU('&Edición'),USE(?Edición)
                           ITEM('Co&rtar'),USE(?Cut),MSG('Remueve el item al portapapeles'),STD(STD:Cut)
                           ITEM('&Copiar'),USE(?Copy),MSG('Copiar item al portapapeles'),STD(STD:Copy)
                           ITEM('&Pegar'),USE(?Paste),MSG('Pegar contenido'),STD(STD:Paste)
                         END
                         MENU('&Examinar'),USE(?Examinar)
                           ITEM('Registro de clientes'),USE(?BrowseCLIENTES),MSG('Examina el Registro de clientes')
                           ITEM('Tipos de baterías'),USE(?BrowseTIPOS),MSG('Examinar Tipos de baterías')
                           ITEM('cajas'),USE(?BrowseCajas),MSG(' Ver cajas')
                           ITEM('Registro histórico de Baterías Saman'),USE(?BrowseSAMAN),MSG('Examinar las Baterías')
                           ITEM('Placas'),USE(?BrowsePLACAS),MSG('Examinar Placas')
                         END
                         MENU('&Reportes'),USE(?ReportMenu),MSG('Datos en Reportes')
                           MENU('Registro de clientes'),USE(?PrintCLIENTES)
                             ITEM('Por código cliente'),USE(?PrintCLI:Porcodi),MSG('Imprime ordenando por código de cliente')
                             ITEM('Apellido y nombre'),USE(?PrintCLI:apeynom),MSG('Imprime clientes ordenados por apellido y nombre')
                           END
                           ITEM('Imprimir tipos por descripción'),USE(?PrintTIP:principal)
                           ITEM('Imprimir cajas por código'),USE(?PrintCAJ:KeyCódigo)
                           MENU('Placas'),USE(?PrintPLACAS)
                             ITEM('Imprimir por código de placa'),USE(?PrintPLA:codiclave)
                             ITEM('Imprimir placas por descripción'),USE(?PrintPLA:descriclave)
                           END
                         END
                         MENU('&Ventana'),USE(?Ventana),MSG('Opciones de ventanas'),STD(STD:WindowList)
                           ITEM('&Mosaico'),USE(?Tile),MSG('Hace visible todas las ventanas'),STD(STD:TileWindow)
                           ITEM('&Cascada'),USE(?Cascade),MSG('Apila todas las ventanas abiertas'),STD(STD:CascadeWindow)
                           ITEM('&Acomodar íconos'),USE(?Arrange),MSG('Alinea todos los íconos'),STD(STD:ArrangeIcons)
                         END
                       END
                       TOOLBAR,AT(0,0,409,21)
                         BUTTON,AT(4,2,16,14),TIP('Go to the First Page'),USE(?TbarBrwTop,TBarBrwTop),DISABLE,ICON('VCRFIRST.ICO')
                         BUTTON,AT(20,2,16,14),TIP('Go to the Prior Page'),USE(?TbarBrwPageUp,TBarBrwPageUp),DISABLE,ICON('VCRPRIOR.ICO')
                         BUTTON,AT(36,2,16,14),TIP('Go to the Prior Record'),USE(?TbarBrwUp,TBarBrwUp),DISABLE,ICON('VCRUP.ICO')
                         BUTTON,AT(52,2,16,14),TIP('Locate record'),USE(?TbarBrwLocate,TBarBrwLocate),DISABLE,ICON('FIND.ICO')
                         BUTTON,AT(68,2,16,14),TIP('Go to the Next Record'),USE(?TbarBrwDown,TBarBrwDown),DISABLE,ICON('VCRDOWN.ICO')
                         BUTTON,AT(84,2,16,14),TIP('Go to the Next Page'),USE(?TbarBrwPageDown,TBarBrwPageDown),DISABLE,ICON('VCRNEXT.ICO')
                         BUTTON,AT(100,2,16,14),TIP('Go to the Last Page'),USE(?TbarBrwBottom,TBarBrwBottom),DISABLE,ICON('VCRLAST.ICO')
                         BUTTON,AT(120,2,16,14),TIP('Select This Record'),USE(?TbarBrwSelect,TBarBrwSelect),DISABLE,ICON('MARK.ICO')
                         BUTTON,AT(136,2,16,14),TIP('Insert a New Record'),USE(?TbarBrwInsert,TBarBrwInsert),DISABLE,ICON('INSERT.ICO')
                         BUTTON,AT(152,2,16,14),TIP('Edit This Record'),USE(?TbarBrwChange,TBarBrwChange),DISABLE,ICON('EDIT.ICO')
                         BUTTON,AT(168,2,16,14),TIP('Delete This Record'),USE(?TbarBrwDelete,TBarBrwDelete),DISABLE,ICON('DELETE.ICO')
                         BUTTON,AT(188,2,16,14),TIP('Previous value'),USE(?TbarBrwHistory,TBarBrwHistory),DISABLE,ICON('DITTO.ICO')
                         BUTTON,AT(204,2,16,14),TIP('Get Help'),USE(?TbarBrwHelp,TBarBrwHelp),DISABLE,ICON('HELP.ICO')
                       END
                     END
  CODE
  PUSHBIND
  SoN= 'S'
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
  IF NOT INRANGE(AppFrame{Prop:Timer},1,100)
    AppFrame{Prop:Timer} = 100
  END
    AppFrame{Prop:StatusText,1} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D18)
    AppFrame{Prop:StatusText,2} = FORMAT(CLOCK(),@T1)
  ACCEPT
    CASE EVENT()
    OF EVENT:OpenWindow
      SplashProcedureThread = START(Inicial)
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      END
      SELECT(1)
    OF EVENT:GainFocus
      ForceRefresh = True
      IF NOT WindowInitialized
        DO InitializeWindow
        WindowInitialized = True
      ELSE
        DO RefreshWindow
      END
    OF Event:Rejected
      BEEP
      DISPLAY(?)
      SELECT(?)
    ELSE
      IF SplashProcedureThread
        IF EVENT() = Event:Accepted
          POST(Event:CloseWindow,,SplashProcedureThread)
          SplashPRocedureThread = 0
        END
      END
      IF INRANGE(ACCEPTED(),TBarBrwFirst,TBarBrwLast) THEN            !Toolbar Browse box navigation control handler
        POST(EVENT:Accepted,ACCEPTED(),SYSTEM{Prop:Active})
        CYCLE
      END
      IF EVENT() = Event:Timer
          AppFrame{Prop:StatusText,1} = CLIP(DisplayDayText[(TODAY()%7)+1]) & ', ' & FORMAT(TODAY(),@D18)
          AppFrame{Prop:StatusText,2} = FORMAT(CLOCK(),@T1)
      END
    END
    CASE ACCEPTED()
    OF ?BrowseCLIENTES
      START(BrowseCLIENTES,050000)
    OF ?BrowseTIPOS
      START(BrowseTIPOS,050000)
    OF ?BrowseCajas
      START(BrowseCajas,050000)
    OF ?BrowseSAMAN
      START(BrowseSAMAN,050000)
    OF ?BrowsePLACAS
      START(BrowsePLACAS,050000)
    OF ?PrintCLI:Porcodi
      START(PrintCLI:Porcodi,050000)
    OF ?PrintCLI:apeynom
      START(PrintCLI:apeynom,050000)
    OF ?PrintTIP:principal
      START(PrintTIP:principal,050000)
    OF ?PrintCAJ:KeyCódigo
      START(PrintCAJ:KeyCódigo,050000)
    OF ?PrintPLA:codiclave
      START(PrintPLA:codiclave,050000)
    OF ?PrintPLA:descriclave
      START(PrintPLA:descriclave,050000)
    END
  END
  DO ProcedureReturn
!---------------------------------------------------------------------------
PrepareProcedure ROUTINE
  FilesOpened = True
  OPEN(AppFrame)
  WindowOpened=True
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
  END
  IF WindowOpened
    CLOSE(AppFrame)
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
  IF AppFrame{Prop:AcceptAll} THEN EXIT.
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
