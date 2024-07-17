const express = require('express');
const { Octokit } = require('@octokit/rest');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());

const GITHUB_TOKEN = process.env.GITHUB_TOKEN;
const GITHUB_REPO_OWNER = process.env.GITHUB_REPO_OWNER;
const GITHUB_REPO_NAME = process.env.GITHUB_REPO_NAME;
const WEBHOOK_PASSCODE = process.env.WEBHOOK_PASSCODE;

const octokit = new Octokit({ auth: GITHUB_TOKEN });

app.post('/webhook', async (req, res) => {
  const { passcode, event_type, file_name, description, triggered_by, created_components, modified_components, deleted_components, created_styles, modified_styles, deleted_styles, created_variables, modified_variables, deleted_variables } = req.body;

  if (passcode !== WEBHOOK_PASSCODE) {
    return res.status(400).send('Invalid passcode');
  }

  if (event_type !== 'LIBRARY_PUBLISH') {
    return res.status(200).send('Event type not handled');
  }

  const updateData = {
    timestamp: new Date().toISOString(),
    file_name,
    description,
    triggered_by: triggered_by.handle,
    created_components,
    modified_components,
    deleted_components,
    created_styles,
    modified_styles,
    deleted_styles,
    created_variables,
    modified_variables,
    deleted_variables
  };

  try {
    // Get current data.json content
    let currentData = [];
    try {
      const { data: currentFile } = await octokit.rest.repos.getContent({
        owner: GITHUB_REPO_OWNER,
        repo: GITHUB_REPO_NAME,
        path: 'data.json',
      });
      const content = Buffer.from(currentFile.content, 'base64').toString();
      currentData = JSON.parse(content);
    } catch (error) {
      if (error.status !== 404) throw error;
      // If file doesn't exist, we'll create it
    }

    // Add new update to the beginning of the array
    currentData.unshift(updateData);

    // Limit to last 50 updates
    currentData = currentData.slice(0, 50);

    // Update or create data.json file
    await octokit.rest.repos.createOrUpdateFileContents({
      owner: GITHUB_REPO_OWNER,
      repo: GITHUB_REPO_NAME,
      path: 'data.json',
      message: 'Update design system changes',
      content: Buffer.from(JSON.stringify(currentData, null, 2)).toString('base64'),
      sha: currentFile ? currentFile.sha : undefined,
    });

    res.status(200).send('GitHub Pages updated');
  } catch (error) {
    console.error('Error updating GitHub:', error);
    res.status(500).send('Error updating GitHub Pages');
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
