function vois = bv_ppi_get_vois(voiFile)
    voiData = BVQXfile(voiFile);
    vois = voiData.VOINames;
end
