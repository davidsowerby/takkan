final openIssuesGQL = r'''query OpenIssues {
  issues(where: { state: {equalTo: "open"} }) {
    count
    edges {
      node {
        state
        title
        description
        objectId
        id
        priority
        number
        createdAt
        updatedAt
      }
    }
  }
}''';