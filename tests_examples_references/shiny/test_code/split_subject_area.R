test_choices_subject_area <- c('Data Science', 
                          'Design',
                          'Education')


person_data$subject_area
class(person_data$subject_area)

data <- gsub(", ", ",", person_data$subject_area)
spl <- unlist(strsplit(data, ","))

spl
class(spl)

'Education' %in% spl
