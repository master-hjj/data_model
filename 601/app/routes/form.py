from flask_wtf.file import FileRequired, FileField, FileAllowed
from wtforms import Form, StringField, validators, FileField, IntegerField
from wtforms.validators import Length, InputRequired, DataRequired, NumberRange, EqualTo


class UpModelappForm(Form):
    model_name = StringField('model_name', validators=[DataRequired()])
    model_description = StringField('model_description', validators=[DataRequired()])
    dataset = StringField('dataset', validators=[DataRequired()])
    network_id = StringField('network_id', validators=[DataRequired()])


class UpDatasetForm(Form):
    name = StringField('name', validators=[DataRequired()])
    data_description = StringField('data_description', validators=[DataRequired()])
    # file = FileField('Dataset File', validators=[FileRequired(), FileAllowed(allowed_file1, 'Only CSV files allowed!')])


class UpNetworkForm(Form):
    network_name = StringField('network_name', validators=[DataRequired()])
    network_func = IntegerField('network_func', validators=[DataRequired(), NumberRange(min=0)])
    is_deep = IntegerField('is_deep')


class UpPreprocessForm(Form):
    preprocess_name = StringField('preprocess_name', validators=[DataRequired()])
    preprocess_description = StringField('preprocess_description', validators=[DataRequired()])

