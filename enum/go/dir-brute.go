package main

import (
	"bufio"
	"fmt"
	"net/http"
	"os"
	"strings"
	"sync"
)

func main() {
	// Check if the required parameters are provided
	if len(os.Args) != 3 {
		fmt.Println("Usage: go run main.go <host> <wordlist>")
		return
	}

	host := os.Args[1]
	wordlistPath := os.Args[2]

	// Check if the host URL contains a protocol scheme (http:// or https://)
	if !strings.HasPrefix(host, "http://") && !strings.HasPrefix(host, "https://") {
		fmt.Println("Invalid host URL. Please include the protocol scheme (http:// or https://).")
		return
	}

	// Set the user agent to Mozilla browser
	userAgent := "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"

	// Read the wordlist file
	wordlistFile, err := os.Open(wordlistPath)
	if err != nil {
		fmt.Println("Error opening wordlist file:", err)
		return
	}
	defer wordlistFile.Close()

	// Get the total number of lines in the wordlist
	totalLines := 0
	scanner := bufio.NewScanner(wordlistFile)
	for scanner.Scan() {
		totalLines++
	}
	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading wordlist file:", err)
		return
	}

	// Reset the wordlist file cursor to the beginning
	wordlistFile.Seek(0, 0)

	// Initialize counters
	wordsTested := 0
	wordsFound := 0

	// Create a wait group to synchronize goroutines
	var wg sync.WaitGroup

	// Iterate over each word in the wordlist
	scanner = bufio.NewScanner(wordlistFile)
	for scanner.Scan() {
		word := scanner.Text()
		wg.Add(1)

		// Launch a goroutine to perform the GET request
		go func(word string) {
			defer wg.Done()

			// Make the GET request with HTTP client
			client := &http.Client{}
			req, err := http.NewRequest("GET", fmt.Sprintf("%s/%s", host, word), nil)
			if err != nil {
				fmt.Printf("Error creating request for word '%s': %v\n", word, err)
				return
			}
			req.Header.Set("User-Agent", userAgent)
			resp, err := client.Do(req)
			if err != nil {
				fmt.Printf("Error making request for word '%s': %v\n", word, err)
				return
			}
			defer resp.Body.Close()

			// Check the response status code
			if resp.StatusCode == http.StatusOK {
				fmt.Println("Found:", host+"/"+word)
				wordsFound++
			}

			wordsTested++

			// Print the progress
			updateProgress(wordsTested, totalLines)
		}(word)
	}

	// Wait for all goroutines to finish
	wg.Wait()

	fmt.Println("\nWords tested:", wordsTested)
	fmt.Println("Words found:", wordsFound)
}

// Function to update the progress
func updateProgress(current, total int) {
	barLength := 50
	filledLength := current * barLength / total
	emptyLength := barLength - filledLength
	progressBar := "[" + strings.Repeat("#", filledLength) + strings.Repeat(" ", emptyLength) + "]"
	fmt.Printf("\r%s %3d%% (%d/%d)", progressBar, current*100/total, current, total)
}
