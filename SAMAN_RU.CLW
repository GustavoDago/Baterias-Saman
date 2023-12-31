                     MEMBER('SAMAN.clw')

HoldPosition         STRING(512),AUTO
Sav                 GROUP,THREAD
CAJ:C�digo             LIKE(CAJ:C�digo)
CLI:C�digo             LIKE(CLI:C�digo)
TIP:Descripci�n        LIKE(TIP:Descripci�n)
                     END


!--------------------------------------------------
RISnap:CLIENTES     PROCEDURE
  CODE
  Sav.CLI:C�digo = CLI:C�digo

!--------------------------------------------------
RIUpdate:CLIENTES    FUNCTION(BYTE FromForm)
  CODE
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,CLIENTES,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Update','CLIENTES')
    DO RICloseFiles
    RETURN(1)
  END
  HoldPosition = POSITION(CLI:Porcodi)
  PUT(CLIENTES)
  IF ERRORCODE()
    RISaveError
    IF SaveErrorCode = RecordChangedErr THEN
      IF FromForm THEN
        StandardWarning(Warn:RIFormUpdateError)
      ELSE
        StandardWarning(Warn:RIUpdateError,'Record Changed by Another Station')
      END
      WATCH(CLIENTES)
      REGET(CLIENTES,HoldPosition)
      DO RICloseFiles
      RETURN(2)
    ELSE
      StandardWarning(Warn:RIUpdateError,'CLIENTES')
      DO RICloseFiles
      RETURN(1)
    END
  END
  IF Sav.CLI:C�digo <> CLI:C�digo
    IF RIUpdate:CLIENTES:SAMAN()
      ROLLBACK
      HIS:CLIENTE = CLI:C�digo
      DO RICloseFiles
      RETURN(1)
    END
  END
  COMMIT
  DO RICloseFiles
  RETURN(0)
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT

!--------------------------------------------------
RISnap:Cajas        PROCEDURE
  CODE
  Sav.CAJ:C�digo = CAJ:C�digo

!--------------------------------------------------
RIUpdate:Cajas       FUNCTION(BYTE FromForm)
  CODE
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,Cajas,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Update','Cajas')
    DO RICloseFiles
    RETURN(1)
  END
  HoldPosition = POSITION(Cajas)
  PUT(Cajas)
  IF ERRORCODE()
    RISaveError
    IF SaveErrorCode = RecordChangedErr THEN
      IF FromForm THEN
        StandardWarning(Warn:RIFormUpdateError)
      ELSE
        StandardWarning(Warn:RIUpdateError,'Record Changed by Another Station')
      END
      WATCH(Cajas)
      REGET(Cajas,HoldPosition)
      DO RICloseFiles
      RETURN(2)
    ELSE
      StandardWarning(Warn:RIUpdateError,'Cajas')
      DO RICloseFiles
      RETURN(1)
    END
  END
  IF Sav.CAJ:C�digo <> CAJ:C�digo
    IF RIUpdate:Cajas:SAMAN()
      ROLLBACK
      HIS:CAJA = CAJ:C�digo
      DO RICloseFiles
      RETURN(1)
    END
  END
  COMMIT
  DO RICloseFiles
  RETURN(0)
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT

!--------------------------------------------------
RISnap:PLACAS       PROCEDURE
  CODE

!--------------------------------------------------
RIUpdate:PLACAS      FUNCTION(BYTE FromForm)
  CODE
  LOGOUT(2,PLACAS)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Update','PLACAS')
    DO RICloseFiles
    RETURN(1)
  END
  HoldPosition = POSITION(PLA:codiclave)
  PUT(PLACAS)
  IF ERRORCODE()
    RISaveError
    IF SaveErrorCode = RecordChangedErr THEN
      IF FromForm THEN
        StandardWarning(Warn:RIFormUpdateError)
      ELSE
        StandardWarning(Warn:RIUpdateError,'Record Changed by Another Station')
      END
      WATCH(PLACAS)
      REGET(PLACAS,HoldPosition)
      DO RICloseFiles
      RETURN(2)
    ELSE
      StandardWarning(Warn:RIUpdateError,'PLACAS')
      DO RICloseFiles
      RETURN(1)
    END
  END
  COMMIT
  DO RICloseFiles
  RETURN(0)
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  EXIT

!--------------------------------------------------
RISnap:SAMAN        PROCEDURE
  CODE

!--------------------------------------------------
RIUpdate:SAMAN       FUNCTION(BYTE FromForm)
  CODE
  LOGOUT(2,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Update','SAMAN')
    DO RICloseFiles
    RETURN(1)
  END
  HoldPosition = POSITION(HIS:PRINCIPAL)
  PUT(SAMAN)
  IF ERRORCODE()
    RISaveError
    IF SaveErrorCode = RecordChangedErr THEN
      IF FromForm THEN
        StandardWarning(Warn:RIFormUpdateError)
      ELSE
        StandardWarning(Warn:RIUpdateError,'Record Changed by Another Station')
      END
      WATCH(SAMAN)
      REGET(SAMAN,HoldPosition)
      DO RICloseFiles
      RETURN(2)
    ELSE
      StandardWarning(Warn:RIUpdateError,'SAMAN')
      DO RICloseFiles
      RETURN(1)
    END
  END
  COMMIT
  DO RICloseFiles
  RETURN(0)
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  EXIT

!--------------------------------------------------
RISnap:TIPOS        PROCEDURE
  CODE
  Sav.TIP:Descripci�n = TIP:Descripci�n

!--------------------------------------------------
RIUpdate:TIPOS       FUNCTION(BYTE FromForm)
  CODE
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,TIPOS,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Update','TIPOS')
    DO RICloseFiles
    RETURN(1)
  END
  HoldPosition = POSITION(TIP:principal)
  PUT(TIPOS)
  IF ERRORCODE()
    RISaveError
    IF SaveErrorCode = RecordChangedErr THEN
      IF FromForm THEN
        StandardWarning(Warn:RIFormUpdateError)
      ELSE
        StandardWarning(Warn:RIUpdateError,'Record Changed by Another Station')
      END
      WATCH(TIPOS)
      REGET(TIPOS,HoldPosition)
      DO RICloseFiles
      RETURN(2)
    ELSE
      StandardWarning(Warn:RIUpdateError,'TIPOS')
      DO RICloseFiles
      RETURN(1)
    END
  END
  IF Sav.TIP:Descripci�n <> TIP:Descripci�n
    IF RIUpdate:TIPOS:SAMAN()
      ROLLBACK
      HIS:TIPO = TIP:Descripci�n
      DO RICloseFiles
      RETURN(1)
    END
  END
  COMMIT
  DO RICloseFiles
  RETURN(0)
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT
!--------------------------------------------------
RIUpdate:CLIENTES:SAMAN FUNCTION

    CODE
    CLEAR(HIS:Record,0)
    HIS:CLIENTE = Sav.CLI:C�digo
    SET(HIS:clienclave,HIS:clienclave)
    LOOP
      NEXT(SAMAN)
      IF ERRORCODE()
        IF ERRORCODE() = BadRecErr
          RETURN(0)
        ELSE
          RISaveError
          StandardWarning(Warn:RecordFetchError,'SAMAN')
          RETURN(1)
        END
      END
      IF HIS:CLIENTE <> Sav.CLI:C�digo
        RETURN(0)
      END
      RISnap:SAMAN
      HIS:CLIENTE = CLI:C�digo
      PUT(SAMAN)
      IF ERRORCODE()
        RISaveError
        StandardWarning(Warn:RIUpdateError,'SAMAN')
        RETURN(1)
      END
    END
!--------------------------------------------------
RIUpdate:Cajas:SAMAN FUNCTION

    CODE
    CLEAR(HIS:Record,0)
    HIS:CAJA = Sav.CAJ:C�digo
    SET(HIS:cajas,HIS:cajas)
    LOOP
      NEXT(SAMAN)
      IF ERRORCODE()
        IF ERRORCODE() = BadRecErr
          RETURN(0)
        ELSE
          RISaveError
          StandardWarning(Warn:RecordFetchError,'SAMAN')
          RETURN(1)
        END
      END
      IF HIS:CAJA <> Sav.CAJ:C�digo
        RETURN(0)
      END
      RISnap:SAMAN
      HIS:CAJA = CAJ:C�digo
      PUT(SAMAN)
      IF ERRORCODE()
        RISaveError
        StandardWarning(Warn:RIUpdateError,'SAMAN')
        RETURN(1)
      END
    END
!--------------------------------------------------
RIUpdate:TIPOS:SAMAN FUNCTION

    CODE
    CLEAR(HIS:Record,0)
    HIS:TIPO = Sav.TIP:Descripci�n
    SET(HIS:tipoclave,HIS:tipoclave)
    LOOP
      NEXT(SAMAN)
      IF ERRORCODE()
        IF ERRORCODE() = BadRecErr
          RETURN(0)
        ELSE
          RISaveError
          StandardWarning(Warn:RecordFetchError,'SAMAN')
          RETURN(1)
        END
      END
      IF HIS:TIPO <> Sav.TIP:Descripci�n
        RETURN(0)
      END
      RISnap:SAMAN
      HIS:TIPO = TIP:Descripci�n
      PUT(SAMAN)
      IF ERRORCODE()
        RISaveError
        StandardWarning(Warn:RIUpdateError,'SAMAN')
        RETURN(1)
      END
    END
