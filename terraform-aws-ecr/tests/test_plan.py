import pytest
import tftest
import os
import unittest
from cached_property import cached_property
from random import randint
import datetime
import uuid



    # def __init__(self, dir):
    #     self.dir = os.getcwd()
class TestTerraformAWSEcr(unittest.TestCase):

    def setUp(self):
        date = datetime.date.today()
        id = uuid.uuid1()
        test_name = f'{date}-{id}'
        self.tf_vars = {
            'create_repo': True,
            'ecr_repo_url_to_ssm': True,
            'name': test_name,
            'ssm_key': test_name
        }

    def test_run(self):
        tf = tftest.TerraformTest(tfdir='../', env=self.tf_vars)
        tf.setup()
        # tf.execute_command('validate')
        # try:
            
        #     plan_out = tf.plan(output=True)
        #     tf.apply(plan_out)
        # except Exception as e:
        #     print(e)
        # finally:
        #     print('done')
        #     tf.destroy(plan_out)
        
        # self.assertIsNotNone(plan_out)
# def test_output_attributes(self):
#     assert self.plan_out.format_version == "0.1"
#     assert self.plan_out.terraform_version == "0.14.0"

# def test_plan():
    

    
    # self.tf.apply(input=self.plan_out, auto_approve=True)
    # self.tf.destory(input=self.plan_out, auto_approve=True)

