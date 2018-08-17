function preds = bv_ppi_get_predictors(sdmFile)
    sdmData = BVQXfile(sdmFile);
    preds = sdmData.PredictorNames(1:sdmData.FirstConfoundPredictor-1);
end
