function net = ssd_zoo(modelName)

caffeModels = {
  'ssd-pascal-vggvd-300', ...
  'ssd-pascal-vggvd-512', ...
  'ssd-pascal-plus-vggvd-300', ...
  'ssd-pascal-vggvd-ft-300', ...
  'ssd-pascal-plus-vggvd-512', ...
  'ssd-pascal-plus-vggvd-ft-300', ...
  'ssd-pascal-plus-vggvd-ft-512', ...
  'ssd-pascal-vggvd-ft-512', ...
  'vgg-vd-16-reduced', ...
} ;

mcnModels = {
  'ssd-mcn-pascal-vggvd-300', ...
  'ssd-mcn-pascal-vggvd-512', ...
} ;

modelNames = horzcat(caffeModels, mcnModels) ;
assert(ismember(modelName, modelNames), 'unrecognised model') ;
modelDir = fullfile(vl_rootnn, 'data/models-import') ;
modelPath = fullfile(modelDir, sprintf('%s.mat', modelName)) ;

if ~exist(modelPath, 'file')
  fetchModel(modelName, modelPath) ;
end

net = dagnn.DagNN.loadobj(load(modelPath)) ;

% ---------------------------------------
function fetchModel(modelName, modelPath)
% ---------------------------------------

waiting = true ;
prompt = sprintf(strcat('%s was not found at %s\nWould you like to ', ...
            ' download it from THE INTERNET (y/n)?\n'), modelName, modelPath) ;

while waiting
  str = input(prompt,'s') ;
  switch str
    case 'y'
      % ensure target directory exists
      if ~exist(fileparts(modelPath), 'dir')
        mkdir(fileparts(modelPath)) ;
      end

      fprintf(sprintf('Downloading %s ... \n', modelName)) ;
      baseUrl = 'http://www.robots.ox.ac.uk/~albanie/models/ssd' ;
      url = sprintf('%s/%s.mat', baseUrl, modelName) ;
      urlwrite(url, modelPath) ;
      return ;
    case 'n'
      throw(exception) ;
    otherwise
      fprintf('input %s not recognised, please use `y` or `n`\n', str) ;
  end
end
