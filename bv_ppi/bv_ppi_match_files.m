function matches = bv_ppi_match_files(vtc_path, sdm_path, num_chars)
    allVtcFiles = dir(fullfile(vtc_path,'\*.vtc'));

    % find matching SDM file for each VTC
    valid_matches =0;
    for vtcIdx=1:length(allVtcFiles)
        [pathstr, name, ext] = fileparts(allVtcFiles(vtcIdx).name);
        
        if isempty(num_chars) || num_chars==0
            sdm_pattern = strcat(name, '.sdm');
        else
            sdm_pattern = strcat(name(1:num_chars), '*.sdm');
        end
        
        allMatchSDM = dir(fullfile(sdm_path,sdm_pattern));
        
        if length(allMatchSDM) > 1
            throw(MException('bv_ppi_match_files:MultipleMatches', ...
                sprintf ('Multiple matches found for file\n%s', allVtcFiles(vtcIdx).name)));
        end
        
        if isempty(allMatchSDM)
            continue;
        end
        
        valid_matches = valid_matches+1;
        matches.vtcFiles{valid_matches} = fullfile(vtc_path, allVtcFiles(vtcIdx).name);
        matches.sdmFiles{valid_matches} = fullfile(sdm_path, allMatchSDM(1).name);
        
    end
end
