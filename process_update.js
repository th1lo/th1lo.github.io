const axios = require('axios');
const fs = require('fs').promises;

async function processUpdate() {
  try {
    console.log('Starting processUpdate function');
    const payload = JSON.parse(process.env.PAYLOAD);
    
    console.log('Received payload:', JSON.stringify(payload, null, 2));

    // Verify passcode
    if (payload.passcode !== process.env.WEBHOOK_PASSCODE) {
      console.error('Invalid passcode');
      process.exit(1);
    }

    // Handle PING event
    if (payload.event_type === 'PING') {
      console.log('Received PING event. Webhook setup successful.');
      process.exit(0);
    }

    // Only process LIBRARY_PUBLISH events
    if (payload.event_type !== 'LIBRARY_PUBLISH') {
      console.log(`Received ${payload.event_type} event. Ignoring.`);
      process.exit(0);
    }

    const { file_key, timestamp, triggered_by, description, file_name, components, styles } = payload;

    console.log('Fetching image preview');
    let preview_image = null;
    try {
      const imageResponse = await axios.get(`https://api.figma.com/v1/images/${file_key}?ids=0&format=png`, {
        headers: { 'X-Figma-Token': process.env.FIGMA_TOKEN }
      });
      preview_image = imageResponse.data.images['0'];
    } catch (error) {
      console.log('Failed to fetch image preview:', error.message);
    }

    // Prepare update data
    const newUpdate = {
      file_name,
      description,
      triggered_by,
      timestamp,
      preview_image,
      created_components: components?.created || [],
      modified_components: components?.modified || [],
      created_styles: styles?.created || [],
      modified_styles: styles?.modified || []
    };

    console.log('Reading existing data.json');
    // Read existing data.json
    let currentData = [];
    try {
      const fileContent = await fs.readFile('data.json', 'utf8');
      currentData = JSON.parse(fileContent);
    } catch (error) {
      console.log('data.json not found or empty, creating new array');
    }

    // Add new update and limit to 50 entries
    currentData.unshift(newUpdate);
    currentData = currentData.slice(0, 50);

    console.log('Writing updated data back to data.json');
    // Write updated data back to data.json
    await fs.writeFile('data.json', JSON.stringify(currentData, null, 2));

    console.log('data.json updated successfully');
  } catch (error) {
    console.error('Error in processUpdate:', error);
    process.exit(1);
  }
}

processUpdate();
