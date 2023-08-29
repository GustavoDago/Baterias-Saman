                     MEMBER('SAMAN.clw')


!--------------------------------------------------
RIDelete:CLIENTES    FUNCTION
Current:Position     STRING(512)
  CODE
  Current:Position = POSITION(CLI:Porcodi)
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,CLIENTES,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Delete','CLIENTES')
    DO RICloseFiles
    RETURN(1)
  END
  REGET(CLI:Porcodi,Current:Position)
  IF RIDelete:CLIENTES:SAMAN()
    ROLLBACK
    DO RICloseFiles
    RETURN(1)
  END
  DELETE(CLIENTES)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:RIDeleteError,'CLIENTES')
    DO RICloseFiles
    RETURN(1)
  ELSE
    COMMIT
    DO RICloseFiles
    RETURN(0)
  END
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT

!--------------------------------------------------
RIDelete:Cajas       FUNCTION
Current:Position     STRING(512)
  CODE
  Current:Position = POSITION(CAJ:KeyCódigo)
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,Cajas,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Delete','Cajas')
    DO RICloseFiles
    RETURN(1)
  END
  REGET(CAJ:KeyCódigo,Current:Position)
  IF RIDelete:Cajas:SAMAN()
    ROLLBACK
    DO RICloseFiles
    RETURN(1)
  END
  DELETE(Cajas)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:RIDeleteError,'Cajas')
    DO RICloseFiles
    RETURN(1)
  ELSE
    COMMIT
    DO RICloseFiles
    RETURN(0)
  END
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT

!--------------------------------------------------
RIDelete:PLACAS      FUNCTION
Current:Position     STRING(512)
  CODE
  Current:Position = POSITION(PLA:codiclave)
  LOGOUT(2,PLACAS)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Delete','PLACAS')
    DO RICloseFiles
    RETURN(1)
  END
  REGET(PLA:codiclave,Current:Position)
  DELETE(PLACAS)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:RIDeleteError,'PLACAS')
    DO RICloseFiles
    RETURN(1)
  ELSE
    COMMIT
    DO RICloseFiles
    RETURN(0)
  END
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  EXIT

!--------------------------------------------------
RIDelete:SAMAN       FUNCTION
Current:Position     STRING(512)
  CODE
  Current:Position = POSITION(HIS:PRINCIPAL)
  LOGOUT(2,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Delete','SAMAN')
    DO RICloseFiles
    RETURN(1)
  END
  REGET(HIS:PRINCIPAL,Current:Position)
  DELETE(SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:RIDeleteError,'SAMAN')
    DO RICloseFiles
    RETURN(1)
  ELSE
    COMMIT
    DO RICloseFiles
    RETURN(0)
  END
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  EXIT

!--------------------------------------------------
RIDelete:TIPOS       FUNCTION
Current:Position     STRING(512)
  CODE
  Current:Position = POSITION(TIP:principal)
  IF SAMAN::Used = 0
    CheckOpen(SAMAN,1)
  END
  SAMAN::Used += 1
  LOGOUT(2,TIPOS,SAMAN)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:LogoutError,'Delete','TIPOS')
    DO RICloseFiles
    RETURN(1)
  END
  REGET(TIP:principal,Current:Position)
  IF RIDelete:TIPOS:SAMAN()
    ROLLBACK
    DO RICloseFiles
    RETURN(1)
  END
  DELETE(TIPOS)
  IF ERRORCODE()
    RISaveError
    StandardWarning(Warn:RIDeleteError,'TIPOS')
    DO RICloseFiles
    RETURN(1)
  ELSE
    COMMIT
    DO RICloseFiles
    RETURN(0)
  END
!----------------------------------------------------------------------
RICloseFiles ROUTINE
!|
!| This routine is called to close any files opened durint RI processing
!|
  SAMAN::Used -= 1
  IF SAMAN::Used = 0 THEN CLOSE(SAMAN).
  EXIT

!--------------------------------------------------
RIDelete:CLIENTES:SAMAN FUNCTION
    CODE
    CLEAR(HIS:Record,0)
    HIS:CLIENTE = CLI:Código
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
      IF CLI:Código <> HIS:CLIENTE
        RETURN(0)
      END
      RISaveError
      StandardWarning(Warn:RestrictDelete,'SAMAN')
      RETURN(1)
    END

!--------------------------------------------------
RIDelete:Cajas:SAMAN FUNCTION
    CODE
    CLEAR(HIS:Record,0)
    HIS:CAJA = CAJ:Código
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
      IF CAJ:Código <> HIS:CAJA
        RETURN(0)
      END
      RISaveError
      StandardWarning(Warn:RestrictDelete,'SAMAN')
      RETURN(1)
    END

!--------------------------------------------------
RIDelete:TIPOS:SAMAN FUNCTION
    CODE
    CLEAR(HIS:Record,0)
    HIS:TIPO = TIP:Descripción
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
      IF TIP:Descripción <> HIS:TIPO
        RETURN(0)
      END
      RISaveError
      StandardWarning(Warn:RestrictDelete,'SAMAN')
      RETURN(1)
    END
