## Avoin Ministeriö

Avoin Ministeriö -verkkopalvelu.

<https://www.avoinministerio.fi/>

Surveyor is the surey libery we use

<https://github.com/NUBIC/surveyor>

## Survey Creation

1. Create a survey surveys dir using [surveyor dsl](https://github.com/NUBIC/surveyor/blob/master/lib/generators/surveyor/templates/surveys/kitchen_sink_survey.rb)

2. Compile survey into database by running the following rake task

        bundle exec rake surveyor FILE=surveys/<survey_file_name>.rb


## Surveys Initialization

1. Configure the SURVEY_ACCESS_CODE for global survey
  This contains the has for global survey with multiple languages
  e.g
  !#config/ini../surveys.rb
  SURVEY_ACCESS_CODE = {
    fi: "avoin-ministerio-attitudes-1-fi",
    se: "avoin-ministerio-attitudes-1-se"

## Survey Reports

1. Run the rake task to generate the reports

        bundle exec rake surveyor:custom_dump

2. Option arguments
        
        bundle exec rake surveyor:custom_dump SURVEY_ACCESS_CODE=<survey_code> SURVEY_VERSION=<survey_version> OUTPUT_DIR=<dir> 

  default values are 
  SURVEY_ACCESS_CODE=<finish_version_of_global_survey> OUTPUT_DIR=tmp with latest survey_version

3. You can see all the survey versions using the following code snippet e.g

       Survey.where("access_code = 'avoin-ministerio-attitudes-1-fi'").each {|s| puts s.survey_version}

## Survey Views

1. Helper method is defined for generating survey buttons
  
       survey_button(user_state = nil, multiple_survey = false, current_language = nil)

    if you set multiple_survey to true it will always show the button even if user has already been surveyd the global survey once.

## Email Survey

1. Generate surveys for users 
       
        get_survey_link("<survey_code>", "<citizen_email_id>")
        
2. Example text

        ApplicationHelper::get_survey_link("avoin-ministerio-attitudes-1-fi", "test@gmail.com")

