#this will create a wiki tree out of a dir

#First Implementation
def create_wikifile()
end

def wikize_dir()
  for each file in dir
    create_wikifile
  end
  for each dir in dir
    wikize_dir
  end
end


#Second implementation
class WikTree
  def init(dir)
    for each file in dir do
      @files.append WikFile.new(file)
    end
    for each dir in dir do
      @trees.append WikTree.new(dir)
    end
  end
end

class WikFile
  def init(file)
    #TODO: wite this function
  end
end
