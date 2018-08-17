
function bv_ppi (matches, voi_file, out_folder, selected_preds, selected_vois, b_confs_zscore)

    vtcFiles = matches.vtcFiles;
    sdmFiles = matches.sdmFiles;

    voiData = BVQXfile(voi_file);

    for fileIdx=1:length(vtcFiles)
        vtcData = BVQXfile(vtcFiles{fileIdx});
        voiTimeCourse = vtcData.VOITimeCourse(voiData);
        sdmData = BVQXfile(sdmFiles{fileIdx});

        for voiIdx=selected_vois

            % create de-meaned vector of voi
            voi_avg=mean(voiTimeCourse(:,voiIdx));
            voi_demean = voiTimeCourse(:,voiIdx) - voi_avg;

            % create zscored vector of voi
            voi_demean_zscored=zscore(voi_demean);

            % create de-meaned vectors of conds
            orig_sdm = sdmData.CopyObject();
            orig_conds_data = orig_sdm.SDMMatrix(:,1:sdmData.FirstConfoundPredictor-1);
            conds_avg=(max(orig_conds_data) - min(orig_conds_data))/2;
            for cond=1:sdmData.FirstConfoundPredictor-1
                conds_demean(:,cond) = sdmData.SDMMatrix(:,cond) - conds_avg(cond);
            end

            % create zscored vector of conds
            conds_zscored=zscore(conds_demean);
                    
            sdmData.SDMMatrix=[];
            sdmData.PredictorNames={};
            sdmData.PredictorColors=[];
                        
            numConds = length(selected_preds);
            
            % put new PPI predictors: multiply de-meaned conds and de-meaned voi 
            for sdmCol=1:length(selected_preds)
                % multiply de-meaned conds and de-meaned voi as updated conds
                sdmData.SDMMatrix(:, sdmCol) = zscore(conds_demean(:,selected_preds(sdmCol)).* voi_demean);
            end

            sdmData.PredictorNames(1:length(selected_preds)) = ...
                    strcat(orig_sdm.PredictorNames(selected_preds), '_PPI_', voiData.VOI(voiIdx).Name);

            sdmData.PredictorColors(1:length(selected_preds),:) = orig_sdm.PredictorColors(selected_preds,:);

            % put original confounds
            num_orig_confs = orig_sdm.NrOfPredictors - orig_sdm.FirstConfoundPredictor;
            destStartCol = size(sdmData.SDMMatrix,2)+1;
            destEndCol = destStartCol + num_orig_confs-1;
            srcStartCol = orig_sdm.FirstConfoundPredictor;
            srcEndCol = srcStartCol+num_orig_confs-1;
            sdmData.SDMMatrix(:, destStartCol:destEndCol) = orig_sdm.SDMMatrix(:,srcStartCol:srcEndCol);
            sdmData.PredictorNames(destStartCol:destEndCol) = orig_sdm.PredictorNames(srcStartCol:srcEndCol);
            sdmData.PredictorColors(destStartCol:destEndCol,:) = orig_sdm.PredictorColors(srcStartCol:srcEndCol,:);
            if b_confs_zscore
                sdmData.SDMMatrix(:, destStartCol:destEndCol) = zscore(sdmData.SDMMatrix(:, destStartCol:destEndCol));
            end
            % put original conditions z-scored as confounds
            destStartCol = size(sdmData.SDMMatrix,2)+1;
            destEndCol = destStartCol + length(selected_preds)-1;
            sdmData.SDMMatrix(:, destStartCol:destEndCol) = conds_zscored(:,selected_preds);
            sdmData.PredictorNames(destStartCol:destEndCol) = orig_sdm.PredictorNames(selected_preds);
            sdmData.PredictorColors(destStartCol:destEndCol,:) = orig_sdm.PredictorColors(selected_preds,:);
            
            % put voi z-scored as confound
            destCol = size(sdmData.SDMMatrix,2)+1;

            sdmData.SDMMatrix(:, destCol) = voi_demean_zscored;
            sdmData.PredictorNames(destCol) = {'Orig_Voi_Demean_Zscore'};

            %copy constant to end
            srcCol = size(orig_sdm.SDMMatrix,2);
            destCol = size(sdmData.SDMMatrix,2)+1;
          
            sdmData.SDMMatrix(:, destCol) = orig_sdm.SDMMatrix(:, srcCol);
            sdmData.PredictorNames(destCol) = orig_sdm.PredictorNames(srcCol);
            sdmData.PredictorColors(destCol,:) = orig_sdm.PredictorColors(srcCol,:);
            
            % set size properties
            sdmData.FirstConfoundPredictor = numConds+1;
            sdmData.NrOfPredictors = size(sdmData.SDMMatrix,2);
            
            % copy to RTC matrix
            sdmData.RTCMatrix=sdmData.SDMMatrix;

            %save
            voiOutDir = fullfile(out_folder, strcat('PPI_',voiData.VOI(voiIdx).Name));
            if ~exist(voiOutDir, 'file')
                mkdir (voiOutDir);
            end
            [pathstr, name, ext]=fileparts(sdmFiles{fileIdx});
            sdmData.SaveAs(fullfile(voiOutDir, strcat(name, '_PPI_', voiData.VOI(voiIdx).Name, ext)));

        end
    end
end

