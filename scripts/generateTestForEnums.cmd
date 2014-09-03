@ECHO OFF

@ECHO Generating enum tests
SET SRCDIR=src\main\java\net\authorize\api\contract\v1
IF NOT EXIST "%SRCDIR%" (
    @ECHO "%SRCDIR%" Does not exist
    EXIT /b 1
)
SET CYGWIN=NODOSFILEWARNING
SET OUTFILE=%TEMP%\AllGeneratedEnumTest.java
SET TEMPLATE=%CD%\resources\EnumTemplate.javat
PUSHD "%SRCDIR%"
grep -i "public enum" * | cut -f2 -d: | cut -c13- | cut -f1 -d" " > %TEMP%\enum.lst

@ECHO.> "%OUTFILE%"
@ECHO     //Generated by java-enum-test on %date%-%time% >> "%OUTFILE%"
@ECHO     @Test >> "%OUTFILE%"
@ECHO     public void allEnumTest() >> "%OUTFILE%"
@ECHO     {>> "%OUTFILE%"
@ECHO.
@ECHO.

FOR /f %%x IN ( %TEMP%\enum.lst) DO (
    @ECHO import net.authorize.api.contract.v1.%%x;
    COPY %TEMPLATE% %TEMP%\%%x.java 1>NUL
    perl -pi -w -e 's/ENUMNAME/%%x/g;' %TEMP%\%%x.java 2>NUL
    TYPE %TEMP%\%%x.java >> "%OUTFILE%"
)
@ECHO     } >> "%OUTFILE%"
@ECHO.>> "%OUTFILE%"
POPD
@ECHO.
@ECHO.
@ECHO The generated test is in "%OUTFILE%"