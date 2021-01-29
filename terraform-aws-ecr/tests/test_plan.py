import pytest
import tftest
import os
import unittest
from cached_property import cached_property
from random import randint
import datetime
import uuid
import boto3

tf_root_dir = "../modules"

class TestTerraformAWSEcr(unittest.TestCase):

    def setUp(self):
        date = datetime.date.today()
        id = uuid.uuid1()
        test_name = f'test-{date}-{id}'
        self.tf_vars = {
            'create_repo': 'true',
            'ecr_repo_url_to_ssm': 'true',
            'name': test_name,
            'ssm_key': test_name
        }
        
        self.tf = tftest.TerraformTest(tfdir=tf_root_dir, env=self.tf_vars)

    @pytest.mark.skipif(os.getenv('SKIP_TEST_RUN') == True,
                    reason="Skipping test deployment")
    @cached_property
    def test_run(self):
        try:
            self.tf.setup()
            self.tf.apply(tf_vars=self.tf_vars)
            self.validate(repo_name)
            yield self.tf.output()

        except Exception as e:
            #TODO: incorporate retry for network errors and terraform bugs
            print(e)
        finally:
            self.tf.destroy(tf_vars=self.tf_vars)

    def test_output(self):
        output = self.test_run()
        print('OUTPUT:')
        print(output)
        self.assertIsNotNone(output['ecr_repo_url'])
        self.assertIsNotNone(output['ssm_arn'])
        self.assertIsNotNone(output['ssm_version'])

    def test_plan(self, json_path=None):

        if json_path != None:
            import json
            with open(json_path) as fp:
                return tftest.TerraformPlanOutput(json.load(fp))
        else:
            self.tf.setup()
            plan = self.tf.plan(output=True, tf_vars=self.tf_vars)
        
    def validate(self, repo_name):
        ecr = boto3.client('ecr')
        ssm = boto3.client('ssm')

        response = ecr.describe_repositories(repositoryNames=[repo_name])
        response = ssm.get_parameter(Name=self.tf_vars['ssm_key'], WithDecryption=False)

# add convert env dict vals to str
# add retries for deployment (if error equals x retry deployment)