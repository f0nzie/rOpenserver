# OpenServer Variables



## MBAL

`MBAL.MB[0].CONSTRAINTS[0].TIME`: Date
`MBAL.MB[0].CONSTRAINTS[0].MAXGASRATE`: Maximum Gas Rate
`MBAL.MB[0].CONSTRAINTS[1].MAXWATRATE`: Maximum Water Rate
`MBAL.MB[0].CONSTRAINTS[0].MAXOILRATE`: Maximum Oil Rate
`MBAL.MB[0].CONSTRAINTS[0].MINOILRATE`: Minimum Oil Rate
`MBAL.MB[0].CONSTRAINTS[0].MANPRESS`: Pressure

`MBAL.MB[0].TRES[{Prediction}][{Prediction}][30].WATCUT`


`MBAL.MB[0].PREDINP.CALCTYPE`: Prediction setup type

### Prediction
`MBAL.MB.TRES[2][0][$].TIME`
`MBAL.MB.TRES[2][0][$].TANKPRESS`
`MBAL.MB.TRES[2][0][$].OILRECOVER`
`MBAL.MB.TRES[2][0][$].OILRATE`
`MBAL.MB.TRES[2][0][$].GASRATE`
`MBAL.MB.TRES[2][0][$].WATRATE`
`MBAL.MB.TRES[2][0][$].WATCUT`



### Well Type Definition
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].TYPE`: Inflow Performance type
    - `CN`
    - `FORCH`
    - `GAS_DARCY`
    - `LIQUID_DARCY`
    - `PSEUDOFORCH`
    - `STRLINE_VOGEL`
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].PI`: Productivity Index
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].TESTGOR`: Test GOR
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].USE_RELPERMS`: PI correction for mobility
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].GRAVELPACK.ENABLED`: Gravel Pack

### More Inflow
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].CONSTRAINTS.GASABANTYPE`: Abandonment by gas
    - `CGR`
    - `DEPTH`
    - `GOR`
    `MBAL.MB[0].PREDWELL[{Well01}].IPR[0].CONSTRAINTS.GORABAN`: Abandonment by gas value
`MBAL.MB[0].PREDWELL[{Well01}].IPR[0].CONSTRAINTS.WATABANTYPE`: Abandonment by water
    - `DEPTH`
    - `WATCUT`
    - `WGR`
    - `WOR`
    
    
### Outflow performance

`MBAL.MB[0].PREDWELL[{Well01}].PERFORMTYPE`: Performance type
    - CFBHP
    - LIFTCURVE
    - SMITH
    - WITLEY
    
