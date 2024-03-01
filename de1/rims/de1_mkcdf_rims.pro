;------------------------------------------------------------------------------
pro de1_mkcdf_rims, yy, doy, out_data_dir=out_data_dir, skip=skip
;------------------------------------------------------------------------------
;Description
; --- Create a cdf file containing the data of RIMS onboard the DE1 satellite.
;Input
; ---
;Keyword
; ---
;Output
; ---
;------------------------------------------------------------------------------
;Setting
;------------------------------------------------------------------------------
;data directory
if not keyword_set(out_data_dir) then out_data_dir = './'
;date
yy2   = yy + 1900
doy_to_month_date, yy2, doy, mm, dd
date  = my_time_string(format=1, yy=yy2, mm=mm, dd=dd)
;file name
fname = out_data_dir + 'de1_rims_' + date + '.cdf'
;keyword
skip  =  0
;------------------------------------------------------------------------------
;Load data
;------------------------------------------------------------------------------
;load data
read_xdr, yy, doy, epoch, oa, den, den2
if epoch[0] eq 0 then begin
  skip = 1
  return
endif
;------------------------------------------------------------------------------
;Calculation
;------------------------------------------------------------------------------
;get parameters
nt       = n_elements(epoch)
ndim_oa  = size(oa , /n_dim) > 1
ndim_den = size(den, /n_dim) > 1
dims_oa  = n_elements(oa[ 0,*])
dims_den = n_elements(den[0,*])
;transpose for tplot variable
epoch = transpose(epoch)
oa    = transpose(oa   )
den   = transpose(den  )
den2  = transpose(den2 )
;open a cdf file
id = cdf_create(fname, /clobber)
;global attribute
gatt_tmp  = cdf_attcreate(id, 'Project', /global_scope)
cdf_attput, id, 'Project', 0, 'DE1'
;create z variable
vary_oa  = replicate('vary', ndim_oa )
vary_den = replicate('vary', ndim_den)
zvr_tmp  = cdf_varcreate(id, 'Epoch'      ,      [1], /cdf_epoch, /zvariable)
zvr_tmp  = cdf_varcreate(id, 'R'          ,      [1], dim=1, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'L-shell'    ,      [1], dim=1, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'MLT'        ,      [1], dim=1, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'sm_long'    ,      [1], dim=1, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'sm_lat'     ,      [1], dim=1, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'Bsm'        ,  [1,1,1], dim=3, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'density_pot', vary_den, dim=dims_den, /cdf_float)
zvr_tmp  = cdf_varcreate(id, 'density_tmp', vary_den, dim=dims_den, /cdf_float)
cdf_varput, id, 'Epoch'      , epoch  , /zvariable
cdf_varput, id, 'R'          , oa[0,*], /zvariable
cdf_varput, id, 'sm_long'    , oa[1,*], /zvariable
cdf_varput, id, 'sm_lat'     , oa[2,*], /zvariable
cdf_varput, id, 'MLT'        , oa[4,*], /zvariable
cdf_varput, id, 'L-shell'    , oa[5,*], /zvariable
cdf_varput, id, 'Bsm'        , oa[[6,7,8],*], /zvariable
cdf_varput, id, 'density_pot', den    , /zvariable
cdf_varput, id, 'density_tmp', den2   , /zvariable
;variable attribute
vatt_tmp = cdf_attcreate(id, 'VAR_TYPE'  , /variable_scope)
vatt_tmp = cdf_attcreate(id, 'SCALETYP'  , /variable_scope)
vatt_tmp = cdf_attcreate(id, 'UNITS'     , /variable_scope)
;add variable attributes to variables
;var_type
cdf_attput, id, 'VAR_TYPE', 'Epoch'      , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'R'          , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'L-shell'    , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'MLT'        , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'sm_long'    , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'sm_lat'     , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'Bsm'        , 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'density_pot', 'data', /zvariable
cdf_attput, id, 'VAR_TYPE', 'density_tmp', 'data', /zvariable
;scaletype
cdf_attput, id, 'SCALETYP', 'density_pot', 'log', /zvariable
cdf_attput, id, 'SCALETYP', 'density_tmp', 'log', /zvariable
;unit
cdf_attput, id, 'UNITS'   , 'R'          , 'R!DE!N'  , /zvariable
cdf_attput, id, 'UNITS'   , 'MLT'        , 'hr'      , /zvariable
cdf_attput, id, 'UNITS'   , 'sm_long'    , 'degree'  , /zvariable
cdf_attput, id, 'UNITS'   , 'sm_lat'     , 'degree'  , /zvariable
cdf_attput, id, 'UNITS'   , 'Bsm'        , 'nT'      , /zvariable
cdf_attput, id, 'UNITS'   , 'density_pot', 'cm!U-3!N', /zvariable
cdf_attput, id, 'UNITS'   , 'density_tmp', 'cm!U-3!N', /zvariable
;close a cdf file
cdf_close, id
;-------------------------------------------------------------------------------
;Output
;-------------------------------------------------------------------------------

end
