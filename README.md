# OC Helm

## Description

This is a simple image using a base Debian image that contains the both a `Helm` as well as the `oc` client. This image
is intended to be used as part of CIs that require interacting with OpenShift clusters and aim to deploy using **Helm**
but also be able to perform actions using the`oc` client.

## Usage

## Software versions

| Software | Version  |
|----------|----------|
| Helm     | 3.14.0   |
| oc       | 4.14.0-0 |
