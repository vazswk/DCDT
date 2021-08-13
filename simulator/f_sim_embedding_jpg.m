function stego = f_sim_embedding_jpg(cover, costmat, payload, nz_number)

%% Get embedding costs
% initialization
cover = double(cover);
wetCost = 10^10;

rhoM1 = costmat;
rhoP1 = costmat;

rhoP1(rhoP1 > wetCost) = wetCost; % threshold on the costs
rhoP1(isnan(rhoP1)) = wetCost; 
rhoP1(cover > 1023) = wetCost;

rhoM1(rhoM1 > wetCost) = wetCost; % threshold on the costs
rhoM1(isnan(rhoM1)) = wetCost; 
rhoM1(cover < -1023) = wetCost;

stego = f_EmbeddingSimulator_seed(cover, rhoP1, rhoM1, floor(payload*nz_number)); 

          
