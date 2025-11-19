# Example Configurations

This directory contains real-world examples of AI Collaboration Framework configurations for different project types.

## Available Examples

### 1. React Web Application
**Directory**: `react-webapp/`

Full-stack React application with:
- Component size limits
- Bundle size monitoring
- Test coverage requirements
- ESLint/Prettier integration
- Performance budgets

**Use Case**: Modern web applications with React, TypeScript, and Node.js backend

### 2. Python Data Science
**Directory**: `python-datascience/`

Data science project with:
- Notebook cell limits
- Model accuracy thresholds
- Memory usage constraints
- Documentation requirements
- Reproducibility checks

**Use Case**: ML/AI projects, data analysis, Jupyter notebooks

### 3. Java Enterprise
**Directory**: `java-enterprise/`

Enterprise Java application with:
- Class size limits
- API response time requirements
- OWASP security compliance
- Test coverage (unit + integration)
- JavaDoc mandatory

**Use Case**: Spring Boot, enterprise microservices, corporate Java applications

### 4. Node.js API
**Directory**: `nodejs-api/`

RESTful API service with:
- Endpoint response times
- Database query performance
- API documentation
- Security headers
- Error handling standards

**Use Case**: Express.js APIs, microservices, backend services

## Using These Examples

### Quick Start

1. **Choose an example** that matches your project type

2. **Copy the configuration**:
   ```bash
   # After installing the framework
   cp examples/react-webapp/VALIDATION_RULES.md .ai-framework/rules/
   ```

3. **Customize for your needs**:
   - Adjust thresholds
   - Add/remove rules
   - Modify check commands

4. **Test the configuration**:
   ```bash
   # Have Local AI validate your project
   "work ready"
   ```

### Adapting Examples

Each example includes:
- **VALIDATION_RULES.md**: Core validation rules
- **README.md**: Setup instructions and customization guide
- **sample-report.md**: Example validation report
- **workflow-guide.md**: AI workflow for this project type

## Contributing Examples

Have a great configuration for a different tech stack? Contribute it!

### Adding a New Example

1. **Create directory**: `examples/your-project-type/`
2. **Add files**:
   - `VALIDATION_RULES.md` - Your rules
   - `README.md` - Setup guide
   - `sample-report.md` - Example output
   - `workflow-guide.md` - AI workflow tips

3. **Update this README** with your example
4. **Submit a PR** with your contribution

See [CONTRIBUTING.md](../CONTRIBUTING.md) for details.

## Technology Coverage

### Currently Available
- ✅ React + TypeScript + Node.js
- ✅ Python + Jupyter + ML/AI
- ✅ Java + Spring Boot
- ✅ Node.js + Express

### Coming Soon
- 🚧 Go microservices
- 🚧 Rust systems programming
- 🚧 Flutter mobile apps
- 🚧 .NET Core APIs
- 🚧 Ruby on Rails
- 🚧 PHP Laravel

### Request an Example

Need an example for a different tech stack? [Open an issue](https://github.com/JamesKayten/AI-Collaboration-Management/issues/new?template=feature_request.md) with:
- Technology stack
- Project type
- Key quality concerns
- Specific validation needs

## Best Practices

### Rule Tuning

Start with strict rules and relax as needed:

```yaml
# Start strict
max_function_lines: 50

# Adjust based on team feedback
max_function_lines: 100  # more realistic for your team
```

### Progressive Adoption

Introduce rules gradually:

1. **Week 1**: File organization and structure
2. **Week 2**: Code complexity limits
3. **Week 3**: Test coverage requirements
4. **Week 4**: Performance budgets
5. **Week 5**: Security scanning

### Team Calibration

Different teams need different rules:

- **Startup**: Focus on speed, lighter rules
- **Enterprise**: Strict compliance, comprehensive rules
- **Open Source**: Focus on documentation and testing
- **Agency**: Client-specific customization

## Support

- **Questions**: Open a [GitHub Discussion](https://github.com/JamesKayten/AI-Collaboration-Management/discussions)
- **Issues**: Report problems with examples
- **Contributions**: Submit your own examples!

---

**Pro Tip**: Start with an example close to your stack, then customize incrementally!
