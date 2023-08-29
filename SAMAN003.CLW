                     MEMBER('SAMAN.clw')          ! This is a MEMBER module
PrintCLI:Porcodi PROCEDURE
RejectRecord         LONG
LocalRequest         LONG
LocalResponse        LONG
FilesOpened          LONG
WindowOpened         LONG
RecordsToProcess     LONG,AUTO
RecordsProcessed     LONG,AUTO
RecordsPerCycle      LONG,AUTO
RecordsThisCycle     LONG,AUTO
PercentProgress      BYTE
RecordStatus         BYTE,AUTO
!-----------------------------------------------------------------------------
Process:View         VIEW(CLIENTES)
                       PROJECT(CLI:Apellido)
                       PROJECT(CLI:CUIT)
                       PROJECT(CLI:Código)
                       PROJECT(CLI:Dirección)
                       PROJECT(CLI:Localidad)
                       PROJECT(CLI:Nombres)
                       PROJECT(CLI:Teléfono)
                       PROJECT(CLI:Teléfono1)
                     END
report               REPORT,AT(1000,1720,6000,7281),PRE(RPT),FONT('Arial',10,,),THOUS
                       HEADER,AT(1000,1000,6000,719)
                         STRING('Clientes por código'),AT(0,20,6000,220),FONT(,,,FONT:bold),CENTER
                         BOX,AT(0,260,6000,460),COLOR(00H),FILL(0C0C0C0H)
                         LINE,AT(1500,260,0,460),COLOR(00H)
                         LINE,AT(3000,260,0,460),COLOR(00H)
                         LINE,AT(4500,260,0,460),COLOR(00H)
                         STRING('COD. CLIENTE'),AT(50,310,1400,170),TRN
                         STRING('Apellido'),AT(1550,310,1400,170),TRN
                         STRING('Nombres'),AT(3050,310,1400,170),TRN
                         STRING('Dirección'),AT(4550,310,1400,170),TRN
                         STRING('Localidad'),AT(50,490,1400,170),TRN
                         STRING('Teléfono'),AT(1550,490,1400,170),TRN
                         STRING('Otro Teléfono'),AT(3050,490,1400,170),TRN
                         STRING('CUIT'),AT(4550,490,1400,170),TRN
                       END
detail                 DETAIL,AT(,,6000,458)
                         LINE,AT(1500,0,0,460),COLOR(00H)
                         LINE,AT(3000,0,0,460),COLOR(00H)
                         LINE,AT(4500,0,0,460),COLOR(00H)
                         STRING(@n6),AT(50,50,1400,170),USE(CLI:Código),RIGHT(1)
                         STRING(@s20),AT(1550,50,1400,170),USE(CLI:Apellido)
                         STRING(@s20),AT(3050,50,1400,170),USE(CLI:Nombres)
                         STRING(@s20),AT(4550,50,1400,170),USE(CLI:Dirección)
                         STRING(@s20),AT(50,230,1400,170),USE(CLI:Localidad)
                         STRING(@s12),AT(1550,230,1400,170),USE(CLI:Teléfono)
                         STRING(@s12),AT(3050,230,1400,170),USE(CLI:Teléfono1)
                         STRING(@K##-########-#K),AT(4550,230,1400,170),USE(CLI:CUIT)
                         LINE,AT(50,460,5900,0),COLOR(00H)
                       END
                       FOOTER,AT(1000,9000,6000,219)
                         STRING(@pPage <<<#p),AT(5250,30,700,135),FONT('Arial',8,,FONT:regular),PAGENO,USE(?PageCount)
                       END
                     END
Progress:Thermometer BYTE
ProgressWindow WINDOW('Progress...'),AT(,,142,59),CENTER,TIMER(1),GRAY,DOUBLE
       PROGRESS,USE(Progress:Thermometer),AT(15,15,111,12),RANGE(0,100)
       STRING(''),AT(0,3,141,10),USE(?Progress:UserString),CENTER
       STRING(''),AT(0,30,141,10),USE(?Progress:PctText),CENTER
       BUTTON('Cancel'),AT(45,42,50,15),USE(?Progress:Cancel)
     END
PrintSkipDetails BOOL,AUTO
PrintPreviewQueue QUEUE,PRE
PrintPreviewImage   STRING(80)
                  END
  CODE
  PUSHBIND
  LocalRequest = GlobalRequest
  LocalResponse = RequestCancelled
  CLEAR(GlobalRequest)
  CLEAR(GlobalResponse)
  IF CLIENTES::Used = 0
    CheckOpen(CLIENTES,1)
  END
  CLIENTES::Used += 1
  BIND(CLI:RECORD)
  FilesOpened = True
  RecordsToProcess = RECORDS(CLIENTES)
  RecordsPerCycle = 25
  RecordsProcessed = 0
  PercentProgress = 0
  OPEN(ProgressWindow)
  Progress:Thermometer = 0
  ?Progress:PctText{Prop:Text} = '0% Completed'
  ProgressWindow{Prop:Text} = 'Generating Report'
  ?Progress:UserString{Prop:Text}=''
  SEND(CLIENTES,'QUICKSCAN=on')
  ACCEPT
    CASE EVENT()
    OF Event:OpenWindow
      SET(CLI:Porcodi)
      Process:View{Prop:Filter} = ''
      IF ERRORCODE()
        StandardWarning(Warn:ViewOpenError)
      END
      OPEN(Process:View)
      IF ERRORCODE()
        StandardWarning(Warn:ViewOpenError)
      END
      LOOP
        DO GetNextRecord
        DO ValidateRecord
        CASE RecordStatus
          OF Record:Ok
            BREAK
          OF Record:OutOfRange
            LocalResponse = RequestCancelled
            BREAK
        END
      END
      IF LocalResponse = RequestCancelled
        POST(Event:CloseWindow)
        CYCLE
      END
      OPEN(report)
      report{Prop:Preview} = PrintPreviewImage
    OF Event:Timer
      LOOP RecordsPerCycle TIMES
        PrintSkipDetails = FALSE
        
        IF ~PrintSkipDetails THEN
          PRINT(RPT:detail)
        END
        
        LOOP
          DO GetNextRecord
          DO ValidateRecord
          CASE RecordStatus
            OF Record:OutOfRange
              LocalResponse = RequestCancelled
              BREAK
            OF Record:OK
              BREAK
          END
        END
        IF LocalResponse = RequestCancelled
          LocalResponse = RequestCompleted
          BREAK
        END
        LocalResponse = RequestCancelled
      END
      IF LocalResponse = RequestCompleted
        POST(Event:CloseWindow)
      END
    END
    CASE FIELD()
    OF ?Progress:Cancel
      CASE Event()
      OF Event:Accepted
        LocalResponse = RequestCancelled
        POST(Event:CloseWindow)
      END
    END
  END
  IF SEND(CLIENTES,'QUICKSCAN=off').
  IF LocalResponse = RequestCompleted
    ENDPAGE(report)
    ReportPreview(PrintPreviewQueue)
    IF GlobalResponse = RequestCompleted
      report{PROP:FlushPreview} = True
    END
  END
  CLOSE(report)
  FREE(PrintPreviewQueue)
  DO ProcedureReturn
ProcedureReturn ROUTINE
!|
!| This routine provides a common procedure exit point for all template
!| generated procedures.
!|
!| First, all of the files opened by this procedure are closed.
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
  END
  IF LocalResponse
    GlobalResponse = LocalResponse
  ELSE
    GlobalResponse = RequestCancelled
  END
  POPBIND
  RETURN
!-----------------------------------------------------------------------------
ValidateRecord       ROUTINE
!|
!| This routine is used to provide for complex record filtering and range limiting. This
!| routine is only generated if you've included your own code in the EMBED points provided in
!| this routine.
!|
  RecordStatus = Record:OutOfRange
  IF LocalResponse = RequestCancelled THEN EXIT.
  RecordStatus = Record:OK
  EXIT
GetNextRecord ROUTINE
!|
!| This routine is used to retrieve the next record from the VIEW.
!|
!| After the record has been retrieved, the PROGRESS control on the
!| Progress window is updated.
!|
  NEXT(Process:View)
  IF ERRORCODE()
    IF ERRORCODE() <> BadRecErr
      StandardWarning(Warn:RecordFetchError,'CLIENTES')
    END
    LocalResponse = RequestCancelled
    EXIT
  ELSE
    LocalResponse = RequestCompleted
  END
  RecordsProcessed += 1
  RecordsThisCycle += 1
  IF PercentProgress < 100
    PercentProgress = (RecordsProcessed / RecordsToProcess)*100
    IF PercentProgress > 100
      PercentProgress = 100
    END
    IF PercentProgress <> Progress:Thermometer THEN
      Progress:Thermometer = PercentProgress
      ?Progress:PctText{Prop:Text} = FORMAT(PercentProgress,@N3) & '% Completed'
      DISPLAY()
    END
  END

