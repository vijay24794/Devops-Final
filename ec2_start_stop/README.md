# dawn
Lambda function to automaticaly stop and start the EC2 instance.

## Prerequisite
- [Node.js](https://nodejs.org/)
- [Yarn](https://yarnpkg.com/)

## Usage

### Set AWS credentials and region
Set environment variable `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_REGION`.
```sh
$ direnv edit . # direnv is not required
export AWS_ACCESS_KEY_ID=AKIAXXXXXXXXXXXXXXXXXX
export AWS_SECRET_ACCESS_KEY=XXXXXXXXXXXXXXXXXXXXXXXXX
export AWS_REGION=ap-northeast-1
```

### Deploy Lambda Functions
Clone this repo.
```sh
$ https://github.com/abhi15sep/Devops-Final.git
$ cd ec2_start_stop
```

Install dependencies.
```sh
$ cd ec2_start_stop
$ yarn
```

Deploy.
```
$ yarn run deploy
```

### Set Tag for EC2 Instance
like...

| Key       | Value         |
|-----------|---------------|
| dawn      | enable        |


### Change Schedule
Edit `cron(0 9 ? * * *)` in `serverless.yml`.  
Caution!! scheduled events use UTC time zone. See [Schedule Expressions for Rules - Amazon CloudWatch Events](http://docs.aws.amazon.com/AmazonCloudWatch/latest/events/ScheduledEvents.html).

### Invoke functions manually
```sh
$ yurn run start
```

```sh
$ yurn run stop
```

### Remove funtions
```sh
$ yarn run remove
```
