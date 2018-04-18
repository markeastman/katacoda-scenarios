We are going to run one of the samples that comes with eap called _kitchensink_. Katacoda itself does not come with
the latest version of eap-cd, so we have to inform the openshift environment how to use the latest image.
To do this we need to load the image stream from a public repository via the command:

``oc replace --force -f https://raw.githubusercontent.com/jboss-container-images/jboss-eap-7-openshift-image/eap-cd/templates/eap-cd-image-stream.json``{{execute}}

And the output should look something like this:

```text
imagestream "jboss-eap71-openshift" replaced
```

To create an application within the new project called 'eap-demo' we could issue a command to pull the template from
a public repository:
``oc replace --force -f https://raw.githubusercontent.com/jboss-openshift/application-templates/master/eap/eap71-basic-s2i.json``

However the memory requirements of this template is set to 1 Gigabyte and this is normally too large for the environment to handle.
In this case we are going to use a different process for creating the application within the project.

Go to the _Browser_ tab and log in using the same developer userid as above. Within the overview click the eap-demo project if not already selected.
On this page you should be able to see a large button called 'Add to project' or at the top right you should see the same text.
Click the text to be shown the dialogue that will allow us to import the template directly. This page has three tab areas near
the top, the catalogue, deploy image, and import YAML / JSON. We want to select the import YAML / JSON option.
We need to paste the json for the reduced memory template into the main text box and then click the create button just below the edit box.

Within the home folder of this environment I have added a copy of the _eap-cd-basic-s2i.json_ file that is a modified version of th etemplate to reduce the memory requirements. You can open the file and copy the text
or use the text below to copy and paste into the edit box.
 
```text
{
    "kind": "Template",
    "apiVersion": "v1",
    "metadata": {
        "annotations": {
            "iconClass": "icon-eap",
            "tags": "eap,javaee,java,jboss",
            "version": "1.4.10",
            "openshift.io/display-name": "JBoss EAP CD (no https)",
            "openshift.io/provider-display-name": "Red Hat, Inc.",
            "description": "An example JBoss Enterprise Application Platform continuous delivery application. For more information about using this template, see https://github.com/jboss-container-images/jboss-eap-7-openshift-image/blob/eap-cd/README.adoc",
            "template.openshift.io/long-description": "This template defines resources needed to develop a JBoss Enterprise Application Platform continuous delivery based application, including a build configuration, application deployment configuration and insecure communication using http.",
            "template.openshift.io/documentation-url": "https://access.redhat.com/documentation/en/red-hat-jboss-enterprise-application-platform/",
            "template.openshift.io/support-url": "https://access.redhat.com"
        },
        "name": "eap-cd-basic-s2i"
    },
    "labels": {
        "template": "eap-cd-basic-s2i",
        "xpaas": "1.4.10"
    },
    "message": "A new JBoss EAP CD based application has been created in your project.",
    "parameters": [
        {
            "displayName": "Application Name",
            "description": "The name for the application.",
            "name": "APPLICATION_NAME",
            "value": "eap-app",
            "required": true
        },
        {
            "displayName": "Git Repository URL",
            "description": "Git source URI for application",
            "name": "SOURCE_REPOSITORY_URL",
            "value": "https://github.com/jboss-developer/jboss-eap-quickstarts.git",
            "required": true
        },
        {
            "displayName": "Git Reference",
            "description": "Git branch/tag reference",
            "name": "SOURCE_REPOSITORY_REF",
            "value": "openshift",
            "required": false
        },
        {
            "displayName": "Context Directory",
            "description": "Path within Git project to build; empty for root project directory.",
            "name": "CONTEXT_DIR",
            "value": "kitchensink",
            "required": false
        },
        {
            "displayName": "Queues",
            "description": "Queue names",
            "name": "MQ_QUEUES",
            "value": "",
            "required": false
        },
        {
            "displayName": "Topics",
            "description": "Topic names",
            "name": "MQ_TOPICS",
            "value": "",
            "required": false
        },
        {
            "displayName": "A-MQ cluster password",
            "description": "A-MQ cluster admin password",
            "name": "MQ_CLUSTER_PASSWORD",
            "from": "[a-zA-Z0-9]{8}",
            "generate": "expression",
            "required": true
        },
        {
            "displayName": "Github Webhook Secret",
            "description": "GitHub trigger secret",
            "name": "GITHUB_WEBHOOK_SECRET",
            "from": "[a-zA-Z0-9]{8}",
            "generate": "expression",
            "required": true
        },
        {
            "displayName": "Generic Webhook Secret",
            "description": "Generic build trigger secret",
            "name": "GENERIC_WEBHOOK_SECRET",
            "from": "[a-zA-Z0-9]{8}",
            "generate": "expression",
            "required": true
        },
        {
            "displayName": "ImageStream Namespace",
            "description": "Namespace in which the ImageStreams for Red Hat Middleware images are installed. These ImageStreams are normally installed in the openshift namespace. You should only need to modify this if you've installed the ImageStreams in a different namespace/project.",
            "name": "IMAGE_STREAM_NAMESPACE",
            "value": "eap-demo",
            "required": true
        },
        {
            "displayName": "JGroups Cluster Password",
            "description": "JGroups cluster password",
            "name": "JGROUPS_CLUSTER_PASSWORD",
            "from": "[a-zA-Z0-9]{8}",
            "generate": "expression",
            "required": true
        },
        {
            "displayName": "Deploy Exploded Archives",
            "description": "Controls whether exploded deployment content should be automatically deployed",
            "name": "AUTO_DEPLOY_EXPLODED",
            "value": "false",
            "required": false
        },
        {
            "displayName": "Maven mirror URL",
            "description": "Maven mirror to use for S2I builds",
            "name": "MAVEN_MIRROR_URL",
            "value": "",
            "required": false
        },
        {
            "displayName": "Maven Additional Arguments",
            "description": "Maven additional arguments to use for S2I builds",
            "name": "MAVEN_ARGS_APPEND",
            "value": "-Dcom.redhat.xpaas.repo.jbossorg",
            "required": false
        },
        {
            "description": "List of directories from which archives will be copied into the deployment folder. If unspecified, all archives in /target will be copied.",
            "name": "ARTIFACT_DIR",
            "value": "",
            "required": false
        },
        {
            "description": "Container memory limit",
            "name": "MEMORY_LIMIT",
            "value": "700Mi",
            "required": false
        }
    ],
    "objects": [
        {
            "kind": "Service",
            "apiVersion": "v1",
            "spec": {
                "ports": [
                    {
                        "port": 8080,
                        "targetPort": 8080
                    }
                ],
                "selector": {
                    "deploymentConfig": "${APPLICATION_NAME}"
                }
            },
            "metadata": {
                "name": "${APPLICATION_NAME}",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                },
                "annotations": {
                    "description": "The web server's http port."
                }
            }
        },
        {
            "kind": "Service",
            "apiVersion": "v1",
            "spec": {
                "clusterIP": "None",
                "ports": [
                    {
                        "name": "ping",
                        "port": 8888
                    }
                ],
                "selector": {
                    "deploymentConfig": "${APPLICATION_NAME}"
                }
            },
            "metadata": {
                "name": "${APPLICATION_NAME}-ping",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                },
                "annotations": {
                    "service.alpha.kubernetes.io/tolerate-unready-endpoints": "true",
                    "description": "The JGroups ping port for clustering."
                }
            }
        },
        {
            "kind": "Route",
            "apiVersion": "v1",
            "id": "${APPLICATION_NAME}-http",
            "metadata": {
                "name": "${APPLICATION_NAME}",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                },
                "annotations": {
                    "description": "Route for application's http service."
                }
            },
            "spec": {
                "to": {
                    "name": "${APPLICATION_NAME}"
                }
            }
        },
        {
            "kind": "ImageStream",
            "apiVersion": "v1",
            "metadata": {
                "name": "${APPLICATION_NAME}",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                }
            }
        },
        {
            "kind": "BuildConfig",
            "apiVersion": "v1",
            "metadata": {
                "name": "${APPLICATION_NAME}",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                }
            },
            "spec": {
                "source": {
                    "type": "Git",
                    "git": {
                        "uri": "${SOURCE_REPOSITORY_URL}",
                        "ref": "${SOURCE_REPOSITORY_REF}"
                    },
                    "contextDir": "${CONTEXT_DIR}"
                },
                "strategy": {
                    "type": "Source",
                    "sourceStrategy": {
                        "env": [
                            {
                                "name": "MAVEN_MIRROR_URL",
                                "value": "${MAVEN_MIRROR_URL}"
                            },
                            {
                                "name": "MAVEN_ARGS_APPEND",
                                "value": "${MAVEN_ARGS_APPEND}"
                            },
                            {
                                "name": "ARTIFACT_DIR",
                                "value": "${ARTIFACT_DIR}"
                            }
                        ],
                        "forcePull": true,
                        "from": {
                            "kind": "ImageStreamTag",
                            "namespace": "${IMAGE_STREAM_NAMESPACE}",
                            "name": "eap-cd-openshift:12"
                        }
                    }
                },
                "output": {
                    "to": {
                        "kind": "ImageStreamTag",
                        "name": "${APPLICATION_NAME}:latest"
                    }
                },
                "triggers": [
                    {
                        "type": "GitHub",
                        "github": {
                            "secret": "${GITHUB_WEBHOOK_SECRET}"
                        }
                    },
                    {
                        "type": "Generic",
                        "generic": {
                            "secret": "${GENERIC_WEBHOOK_SECRET}"
                        }
                    },
                    {
                        "type": "ImageChange",
                        "imageChange": {}
                    },
                    {
                        "type": "ConfigChange"
                    }
                ]
            }
        },
        {
            "kind": "DeploymentConfig",
            "apiVersion": "v1",
            "metadata": {
                "name": "${APPLICATION_NAME}",
                "labels": {
                    "application": "${APPLICATION_NAME}"
                }
            },
            "spec": {
                "strategy": {
                    "type": "Recreate"
                },
                "triggers": [
                    {
                        "type": "ImageChange",
                        "imageChangeParams": {
                            "automatic": true,
                            "containerNames": [
                                "${APPLICATION_NAME}"
                            ],
                            "from": {
                                "kind": "ImageStreamTag",
                                "name": "${APPLICATION_NAME}:latest"
                            }
                        }
                    },
                    {
                        "type": "ConfigChange"
                    }
                ],
                "replicas": 1,
                "selector": {
                    "deploymentConfig": "${APPLICATION_NAME}"
                },
                "template": {
                    "metadata": {
                        "name": "${APPLICATION_NAME}",
                        "labels": {
                            "deploymentConfig": "${APPLICATION_NAME}",
                            "application": "${APPLICATION_NAME}"
                        }
                    },
                    "spec": {
                        "terminationGracePeriodSeconds": 75,
                        "containers": [
                            {
                                "name": "${APPLICATION_NAME}",
                                "image": "${APPLICATION_NAME}",
                                "imagePullPolicy": "Always",
                                "resources": {
                                    "limits": {
                                        "memory": "${MEMORY_LIMIT}"
                                    }
                                },
                                "livenessProbe": {
                                    "exec": {
                                        "command": [
                                            "/bin/bash",
                                            "-c",
                                            "/opt/eap/bin/livenessProbe.sh"
                                        ]
                                    },
                                    "initialDelaySeconds": 60
                                },
                                "readinessProbe": {
                                    "exec": {
                                        "command": [
                                            "/bin/bash",
                                            "-c",
                                            "/opt/eap/bin/readinessProbe.sh"
                                        ]
                                    }
                                },
                                "ports": [
                                    {
                                        "name": "jolokia",
                                        "containerPort": 8778,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "http",
                                        "containerPort": 8080,
                                        "protocol": "TCP"
                                    },
                                    {
                                        "name": "ping",
                                        "containerPort": 8888,
                                        "protocol": "TCP"
                                    }
                                ],
                                "env": [
                                    {
                                        "name": "JGROUPS_PING_PROTOCOL",
                                        "value": "openshift.DNS_PING"
                                    },
                                    {
                                        "name": "OPENSHIFT_DNS_PING_SERVICE_NAME",
                                        "value": "${APPLICATION_NAME}-ping"
                                    },
                                    {
                                        "name": "OPENSHIFT_DNS_PING_SERVICE_PORT",
                                        "value": "8888"
                                    },
                                    {
                                        "name": "MQ_CLUSTER_PASSWORD",
                                        "value": "${MQ_CLUSTER_PASSWORD}"
                                    },
                                    {
                                        "name": "MQ_QUEUES",
                                        "value": "${MQ_QUEUES}"
                                    },
                                    {
                                        "name": "MQ_TOPICS",
                                        "value": "${MQ_TOPICS}"
                                    },
                                    {
                                        "name": "JGROUPS_CLUSTER_PASSWORD",
                                        "value": "${JGROUPS_CLUSTER_PASSWORD}"
                                    },
                                    {
                                        "name": "AUTO_DEPLOY_EXPLODED",
                                        "value": "${AUTO_DEPLOY_EXPLODED}"
                                    }
                                ]
                            }
                        ]
                    }
                }
            }
        }
    ]
}
```

When you click the create button you will be presented with a dialog that asks if you want to 'Process the template'
or 'Save the template', select the process option and continue.

When the next dialog is displayed scrolldown it until you find the section that mentions the '* ImageStream Namespace' with 
a defaulted value of _eap-demo_. This field needs to be changed to the project name you created at the start of the scenario
or the project you imported the image stream into.
After changing the field you can submit the dialog and build process.

You will be presented with a final dialog informing you of what you have submitted and at the top will be a large link
to the overview of the project. You can click this link and then watch the build process complete and then the deployment complete.
This will take a few minutes.
