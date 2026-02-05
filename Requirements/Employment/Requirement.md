
# Objective
Create an CRUD api for the Employment resource in Intelligent Office.

# Technicals
## Database
- Source table is in FactFind database called TEmploymentDetails, TEmploymentHistory (for past empoyments), TEmpymentInformation, TEmploymentBenfit.

## Legacy Contract
```
{
  "startsOn": null,
  "endsOn": null,
  "occupation": null,
  "intendedRetirementAge": null,
  "employer": null,
  "address": {
    "line1": null,
    "line2": null,
    "line3": null,
    "line4": null,
    "locality": null,
    "postalCode": null,
    "country": {
      "isoCode": "st"
    },
    "county": {
      "code": "string"
    }
  },
  "employmentBusinessType": null,
  "inProbation": null,
  "probationPeriodInMonths": null,
  "client": {},
  "industryType": null,
  "employmentStatusDescription": null,
  "employmentStatus": "Unknown"
}
```

# Requirement
- Create a new api CONTRACT extending the current contract to include gaps provided in the Fact Find Data Analysis v6.0 ( use Entity column to lookup for resource name).
- With modifications to existing tables and suggestion for new ones. 
- Use the employment source code in Monolith.FactFind as baseline for creating new or existing contracts.

# Process 
Create a development plan with tasks, group tasks into slices that can be deployed, tested and released as unit of value.



