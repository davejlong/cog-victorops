namespace :image do
  task :build do
    sh 'docker build -t cagedata/victorops-cog .'
    sh 'docker tag cagedata/victorops-cog cagedata/victorops-cog:0.1.4'
  end

  task :push do
    sh 'docker push cagedata/victorops-cog'
  end
end
